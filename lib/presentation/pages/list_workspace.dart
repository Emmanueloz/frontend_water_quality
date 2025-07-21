import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkspaceProvider>(context, listen: false).fetchWorkspaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        context.goNamed(
          Routes.workspaces.name,
          queryParameters: {
            "type": ListWorkspaces.mine.name,
          },
        );
      } else if (index == 1) {
        context.goNamed(
          Routes.workspaces.name,
          queryParameters: {
            "type": ListWorkspaces.shared.name,
          },
        );
      }
    }

    return Layout(
      title: "Espacios de trabajo",
      selectedIndex: widget.type == ListWorkspaces.mine ? 0 : 1,
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
      ],
      builder: (context, screenSize) {
        return Consumer<WorkspaceProvider>(
          builder: (context, workspaceProvider, child) {
            if (widget.type == ListWorkspaces.shared) {
              return MainGridWorkspaces(
                type: widget.type,
                screenSize: screenSize,
                isLoading: workspaceProvider.isLoading,
                itemCount: workspaceProvider.workspacesShared.length,
                itemBuilder: (context, index) {
                  final workspace = workspaceProvider.workspacesShared[index];
                  return WorkspaceCard(
                    id: workspace.id ?? '',
                    title: workspace.name ?? "Sin nombre",
                    owner: workspace.user?.username ?? "Sin propietario",
                    type: workspace.type?.nameSpanish ?? "Privado",
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
              type: widget.type,
              screenSize: screenSize,
              isLoading: workspaceProvider.isLoading,
              itemCount: workspaceProvider.workspaces.length,
              itemBuilder: (context, index) {
                final workspace = workspaceProvider.workspaces[index];
                return WorkspaceCard(
                  id: workspace.id ?? '',
                  title: workspace.name ?? "Sin nombre",
                  owner: workspace.user?.username ?? "Sin propietario",
                  type: workspace.type?.nameSpanish ?? "Privado",
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
