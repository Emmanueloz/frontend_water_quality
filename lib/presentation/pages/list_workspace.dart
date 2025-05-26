import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_grid_workspaces.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ListWorkspace extends StatelessWidget {
  final ListWorkspaces type;
  const ListWorkspace({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        context.goNamed(
          Routes.listWorkspace.name,
          pathParameters: {
            "type": ListWorkspaces.mine.name,
          },
        );
      } else if (index == 1) {
        context.goNamed(
          Routes.listWorkspace.name,
          pathParameters: {
            "type": ListWorkspaces.shared.name,
          },
        );
      }
    }

    return Layout(
      title: "Espacios de trabajo",
      selectedIndex: type == ListWorkspaces.mine ? 0 : 1,
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
        if (screenSize == ScreenSize.mobile ||
            screenSize == ScreenSize.tablet) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: MainGridWorkspaces(
              type: type,
              screenSize: screenSize,
              children: type == ListWorkspaces.mine
                  ? _getWorkspacesCard(context)
                  : _getWorkspacesSharedCard(context),
            ),
          );
        }

        return MainGridWorkspaces(
          type: type,
          screenSize: screenSize,
          children: type == ListWorkspaces.mine
              ? _getWorkspacesCard(context)
              : _getWorkspacesSharedCard(context),
        );
      },
    );
  }

  List<Widget> _getWorkspacesCard(BuildContext context) {
    return [
      WorkspaceCard(
        id: "1",
        title: "Espacio de trabajo 1",
        owner: "David",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "1",
            },
          );
        },
      ),
      WorkspaceCard(
        id: "2",
        title: "Espacio de trabajo 2",
        owner: "David",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "2",
            },
          );
        },
      ),
      WorkspaceCard(
        id: "3",
        title: "Espacio de trabajo 3",
        owner: "David",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "3",
            },
          );
        },
      ),
      WorkspaceCard(
        id: "4",
        title: "Espacio de trabajo 4",
        owner: "David",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "4",
            },
          );
        },
      ),
    ];
  }

  List<Widget> _getWorkspacesSharedCard(BuildContext context) {
    return [
      WorkspaceCard(
        id: "5",
        title: "Espacio de trabajo 5",
        owner: "Angel",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "5",
            },
          );
        },
      ),
      WorkspaceCard(
        id: "6",
        title: "Espacio de trabajo 6",
        owner: "Daniel",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "6",
            },
          );
        },
      ),
      WorkspaceCard(
        id: "7",
        title: "Espacio de trabajo 7",
        owner: "Raul",
        type: "Privado",
        onTap: () {
          context.goNamed(
            Routes.viewWorkspace.name,
            pathParameters: {
              'id': "7",
            },
          );
        },
      ),
    ];
  }
}
