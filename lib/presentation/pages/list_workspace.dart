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
  bool isLoadingPublic = false;

  // Flags para rastrear qué tipos ya se han cargado
  bool _hasLoadedOwn = false;
  bool _hasLoadedShared = false;
  bool _hasLoadedAll = false;
  bool _hasLoadedPublic = false;

  String? errorOwn;
  String? errorShared;
  String? errorAll;
  String? errorPublic;

  List<Workspace> ownWorkspaces = [];
  List<Workspace> sharedWorkspaces = [];
  List<Workspace> allWorkspaces = [];
  List<Workspace> publicWorkspaces = [];

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
      case ListWorkspaces.public:
        currentIndex = 2;
        break;
      case ListWorkspaces.all:
        currentIndex = 3;
        break;
    }
  }

  Future<void> _loadWorkspaces() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      return;
    }

    // Solo cargar el tipo actual
    switch (_type) {
      case ListWorkspaces.mine:
        if (!_hasLoadedOwn) {
          await _fetchOwnWorkspaces();
          _hasLoadedOwn = true;
        }
        break;
      case ListWorkspaces.shared:
        if (!_hasLoadedShared) {
          await _fetchSharedWorkspaces();
          _hasLoadedShared = true;
        }
        break;
      case ListWorkspaces.public:
        if (!_hasLoadedPublic) {
          await _fetchPublicWorkspaces();
          _hasLoadedPublic = true;
        }
        break;
      case ListWorkspaces.all:
        if (!_hasLoadedAll && authProvider.user?.rol == AppRoles.admin) {
          await _fetchAllWorkspaces();
          _hasLoadedAll = true;
        }
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<WorkspaceProvider>(context);

    // Verificar si el tipo actual necesita recarga
    final typeKey = _type.name;
    if (provider.shouldReloadType(typeKey)) {
      _reloadCurrentType();
      provider.confirmListReloaded(type: typeKey);
    }
  }

  Future<void> _reloadCurrentType() async {
    switch (_type) {
      case ListWorkspaces.mine:
        await _fetchOwnWorkspaces();
        break;
      case ListWorkspaces.shared:
        await _fetchSharedWorkspaces();
        break;
      case ListWorkspaces.public:
        await _fetchPublicWorkspaces();
        break;
      case ListWorkspaces.all:
        await _fetchAllWorkspaces();
        break;
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

  Future<void> _fetchPublicWorkspaces() async {
    setState(() {
      isLoadingPublic = true;
      errorPublic = null;
    });

    final provider = Provider.of<WorkspaceProvider>(context, listen: false);
    final Result<List<Workspace>> result = await provider.getPublicWorkspaces();

    if (mounted) {
      setState(() {
        errorPublic = result.message;
        publicWorkspaces = result.value ?? [];
        isLoadingPublic = false;
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
      // Cargar si no se ha cargado aún
      if (!_hasLoadedOwn) {
        _loadWorkspaces();
      }
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
      // Cargar si no se ha cargado aún
      if (!_hasLoadedShared) {
        _loadWorkspaces();
      }
      context.goNamed(
        Routes.workspaces.name,
        queryParameters: {
          "type": ListWorkspaces.shared.name,
        },
      );
    } else if (index == 2) {
      setState(() {
        _type = ListWorkspaces.public;
      });
      // Cargar si no se ha cargado aún
      if (!_hasLoadedPublic) {
        _loadWorkspaces();
      }
      context.goNamed(
        Routes.workspaces.name,
        queryParameters: {
          "type": ListWorkspaces.public.name,
        },
      );
    } else if (index == 3) {
      setState(() {
        _type = ListWorkspaces.all;
      });
      // Cargar si no se ha cargado aún
      if (!_hasLoadedAll) {
        _loadWorkspaces();
      }
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
        NavigationItem(
          label: "Publicos",
          icon: Icons.public_outlined,
          selectedIcon: Icons.public,
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
                screenSize: screenSize,
              );
            },
          );
        }

        if (_type == ListWorkspaces.public) {
          return MainGridWorkspaces(
            type: _type,
            screenSize: screenSize,
            isLoading: isLoadingPublic,
            errorMessage: errorPublic,
            itemCount: publicWorkspaces.length,
            onRefresh: _fetchPublicWorkspaces,
            itemBuilder: (context, index) {
              final workspace = publicWorkspaces[index];
              return WorkspaceCard(
                id: workspace.id ?? '',
                title: workspace.name ?? "Sin nombre",
                owner: workspace.user?.username ?? "No disponible",
                type: workspace.type,
                onTap: () {
                  context.goNamed(
                    Routes.workspace.name,
                    pathParameters: {
                      'id': workspace.id ?? '',
                    },
                  );
                },
                screenSize: screenSize,
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
                screenSize: screenSize,
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
              screenSize: screenSize,
            );
          },
        );
      },
    );
  }
}
