import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_grid_workspaces.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/workspace_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListWorkspace extends StatefulWidget {
  final ListWorkspaces type;
  const ListWorkspace({super.key, required this.type});

  @override
  State<ListWorkspace> createState() => _ListWorkspaceState();
}

class _ListWorkspaceState extends State<ListWorkspace> {
  int currentIndex = 0;
  ListWorkspaces _type = ListWorkspaces.mine;

  @override
  void initState() {
    super.initState();

    _type = widget.type;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkspaceProvider>(context, listen: false)
          .fetchWorkspacesUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    void onDestinationSelected(int index) {
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

    return Layout(
      title: "Espacios de trabajo",
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
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
        return Consumer<WorkspaceProvider>(
          builder: (context, workspaceProvider, child) {
            if (_type == ListWorkspaces.all) {
              return MainGridWorkspaces(
                type: _type,
                screenSize: screenSize,
                errorMessage: workspaceProvider.errorMessageAll,
                isLoading: workspaceProvider.isLoadingAll,
                itemCount: workspaceProvider.workspacesAll.length,
                onRefresh: () =>
                    workspaceProvider.fetchWorkspacesAll(isRecharge: true),
                itemBuilder: (context, index) {
                  final workspace = workspaceProvider.workspacesAll[index];
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
                isLoading: workspaceProvider.isLoadingShared,
                errorMessage: workspaceProvider.errorMessageShared,
                itemCount: workspaceProvider.workspacesShared.length,
                onRefresh: () =>
                    workspaceProvider.fetchWorkspacesShare(isRecharge: true),
                itemBuilder: (context, index) {
                  final workspace = workspaceProvider.workspacesShared[index];
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
              isLoading: workspaceProvider.isLoading,
              errorMessage: workspaceProvider.errorMessage,
              itemCount: workspaceProvider.workspaces.length,
              onRefresh: () =>
                  workspaceProvider.fetchWorkspaces(isRecharge: true),
              itemBuilder: (context, index) {
                final workspace = workspaceProvider.workspaces[index];
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
      },
    );
  }
}
