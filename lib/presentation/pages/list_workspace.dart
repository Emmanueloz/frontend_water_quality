import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_grid_workspaces.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ListWorkspace extends StatelessWidget {
  final ListWorkspaces type;
  const ListWorkspace({super.key, required this.type});

  void onDestinationSelected(BuildContext context, int index) {
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

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacios de trabajo",
      selectedIndex: type == ListWorkspaces.mine ? 0 : 1,
      onDestinationSelected: (int index) {
        onDestinationSelected(context, index);
      },
      destinations: [
        NavigationDestination(
          label: "Mis espacios",
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
        ),
        NavigationDestination(
          label: "Compartidos",
          icon: const Icon(Icons.share_outlined),
          selectedIcon: const Icon(Icons.share),
        ),
      ],
      builder: (context, screenSize) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: _buildMainContent(context, screenSize),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, ScreenSize screenSize) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return MainGridWorkspaces(
        type: type,
        screenSize: screenSize,
        children: type == ListWorkspaces.mine
            ? _getWorkspacesCard(context)
            : _getWorkspacesSharedCard(context),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Sidebar(
          screenSize: screenSize,
          selectedIndex: type == ListWorkspaces.mine ? 0 : 1,
          destinations: [
            NavigationRailDestination(
              label: Text("Medidores"),
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
            ),
            NavigationRailDestination(
              label: Text("Compartidos"),
              icon: const Icon(Icons.share_outlined),
              selectedIcon: const Icon(Icons.share),
            ),
          ],
          onDestinationSelected: (int index) {
            onDestinationSelected(context, index);
          },
        ),
        MainGridWorkspaces(
          type: type,
          screenSize: screenSize,
          children: type == ListWorkspaces.mine
              ? _getWorkspacesCard(context)
              : _getWorkspacesSharedCard(context),
        ),
      ],
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
