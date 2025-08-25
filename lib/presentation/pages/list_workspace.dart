import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_grid_workspaces.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/workspace_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:frontend_water_quality/infrastructure/notification_service.dart';

class ListWorkspace extends StatefulWidget {
  final ListWorkspaces type;
  const ListWorkspace({super.key, required this.type});

  @override
  State<ListWorkspace> createState() => _ListWorkspaceState();
}

class _ListWorkspaceState extends State<ListWorkspace>
    with WidgetsBindingObserver {
  int currentIndex = 0;
  final NotificationService _notificationService = NotificationService();
  bool _isNotificationInitialized = false;
  ListWorkspaces _type = ListWorkspaces.mine;

  bool isLoadingOwn = false;
  bool isLoadingShared = false;
  bool isLoadingAll = false;

  String? errorOwn;
  String? errorShared;
  String? errorAll;

  List<Workspace> ownWorkspaces = [];
  List<Workspace> sharedWorkspaces = [];
  List<Workspace> allWorkspaces = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _type = widget.type;

    _setInitialIndex();
    _loadWorkspaces();
    _initNotificationService();
  }

  void _setInitialIndex() {
    switch (widget.type) {
      case ListWorkspaces.mine:
        currentIndex = 0;
        break;
      case ListWorkspaces.shared:
        currentIndex = 1;
        break;
      case ListWorkspaces.all:
        currentIndex = 2;
        break;
    }
  }

  Future<void> _loadWorkspaces() async {
    await Future.wait([
      _fetchOwnWorkspaces(),
      _fetchSharedWorkspaces(),
      _fetchAllWorkspaces(),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<WorkspaceProvider>(context);
    if (provider.shouldReloadList) {
      _loadWorkspaces();
      provider.confirmListReloaded();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _initNotificationService();
    } else if (state == AppLifecycleState.detached) {
      if (_isNotificationInitialized) {
        await _notificationService.dispose();
        _isNotificationInitialized = false;
      }
    }
  }

  Future<void> _initNotificationService() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_isNotificationInitialized &&
        authProvider.isAuthenticated &&
        authProvider.user?.uid != null) {
      try {
        await _notificationService.init(authProvider.user!.uid);
        _isNotificationInitialized = true;
      } catch (e) {
        debugPrint('Error initializing notification service: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isNotificationInitialized) {
      _notificationService.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchOwnWorkspaces() async {
    setState(() {
      isLoadingOwn = true;
      errorOwn = null;
    });

    final provider = Provider.of<WorkspaceProvider>(context, listen: false);
    final Result<List<Workspace>> result = await provider.getWorkspaces();

    if (mounted) {
      setState(() {
        errorOwn = result.message;
        ownWorkspaces = result.value ?? [];
        isLoadingOwn = false;
      });
    }
  }

  Future<void> _fetchSharedWorkspaces() async {
    setState(() {
      isLoadingShared = true;
      errorShared = null;
    });

    final provider = Provider.of<WorkspaceProvider>(context, listen: false);
    final Result<List<Workspace>> result = await provider.getSharedWorkspaces();

    if (mounted) {
      setState(() {
        errorShared = result.message;
        sharedWorkspaces = result.value ?? [];
        isLoadingShared = false;
      });
    }
  }

  Future<void> _fetchAllWorkspaces() async {
    setState(() {
      isLoadingAll = true;
      errorAll = null;
    });

    final provider = Provider.of<WorkspaceProvider>(context, listen: false);
    final Result<List<Workspace>> result = await provider.getAllWorkspaces();

    if (mounted) {
      setState(() {
        errorAll = result.message;
        allWorkspaces = result.value ?? [];
        isLoadingAll = false;
      });
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      setState(() {
        _type = ListWorkspaces.mine;
      });
      context.goNamed(
        Routes.workspaces.name,
        queryParameters: {
          "type": ListWorkspaces.mine.name,
        },
      );
    } else if (index == 1) {
      setState(() {
        _type = ListWorkspaces.shared;
      });
      context.goNamed(
        Routes.workspaces.name,
        queryParameters: {
          "type": ListWorkspaces.shared.name,
        },
      );
    } else if (index == 2) {
      setState(() {
        _type = ListWorkspaces.all;
      });
      context.goNamed(
        Routes.workspaces.name,
        queryParameters: {
          "type": ListWorkspaces.all.name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Layout(
      title: "Espacios de trabajo",
      selectedIndex: currentIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: [
        NavigationItem(
          label: "Mis espacios",
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
        ),
        NavigationItem(
          label: "Compartidos",
          icon: Icons.share_outlined,
          selectedIcon: Icons.share,
        ),
        if (authProvider.user?.rol == AppRoles.admin)
          NavigationItem(
            label: "Todos",
            icon: Icons.all_inclusive_outlined,
            selectedIcon: Icons.all_inclusive,
          ),
      ],
      builder: (context, screenSize) {
        if (_type == ListWorkspaces.all) {
          return MainGridWorkspaces(
            type: _type,
            screenSize: screenSize,
            isLoading: isLoadingAll,
            errorMessage: errorAll,
            itemCount: allWorkspaces.length,
            onRefresh: _fetchAllWorkspaces,
            itemBuilder: (context, index) {
              final workspace = allWorkspaces[index];
              return WorkspaceCard(
                id: workspace.id ?? '',
                title: workspace.name ?? "Sin nombre",
                owner: workspace.user?.username ?? "Sin propietario",
                type: workspace.type,
                onTap: () {
                  context.goNamed(
                    Routes.workspace.name,
                    pathParameters: {
                      'id': workspace.id ?? '',
                    },
                  );
                },
              );
            },
          );
        }

        if (_type == ListWorkspaces.shared) {
          return MainGridWorkspaces(
            type: _type,
            screenSize: screenSize,
            isLoading: isLoadingShared,
            errorMessage: errorShared,
            itemCount: sharedWorkspaces.length,
            onRefresh: _fetchSharedWorkspaces,
            itemBuilder: (context, index) {
              final workspace = sharedWorkspaces[index];
              return WorkspaceCard(
                id: workspace.id ?? '',
                title: workspace.name ?? "Sin nombre",
                owner: workspace.user?.username ?? "Sin propietario",
                type: workspace.type,
                onTap: () {
                  context.goNamed(
                    Routes.workspace.name,
                    pathParameters: {
                      'id': workspace.id ?? '',
                    },
                  );
                },
              );
            },
          );
        }

        return MainGridWorkspaces(
          type: _type,
          screenSize: screenSize,
          isLoading: isLoadingOwn,
          errorMessage: errorOwn,
          itemCount: ownWorkspaces.length,
          onRefresh: _fetchOwnWorkspaces,
          itemBuilder: (context, index) {
            final workspace = ownWorkspaces[index];
            return WorkspaceCard(
              id: workspace.id ?? '',
              title: workspace.name ?? "Sin nombre",
              owner: workspace.user?.username ?? "Sin propietario",
              type: workspace.type,
              onTap: () {
                context.goNamed(
                  Routes.workspace.name,
                  pathParameters: {
                    'id': workspace.id ?? '',
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
