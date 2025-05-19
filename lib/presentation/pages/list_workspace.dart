import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ListWorkspace extends StatelessWidget {
  final ListWorkspaces type;
  const ListWorkspace({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacios de trabajo",
      builder: (context, screenSize) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: _buildMainContent(context, screenSize),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, ScreenSize screenSize) {
    int crossAxisCount;
    double maxWidth;
    double gap;

    if (screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      maxWidth = double.infinity;
      gap = 5;
    } else if (screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
      maxWidth = double.infinity;
      gap = 5;
    } else if (screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
      maxWidth = 800;
      gap = 10;
    } else {
      crossAxisCount = 4;
      maxWidth = 1000;
      gap = 16;
    }

    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return Column(
        spacing: 10,
        children: [
          ToggleButtons(
            isSelected: [
              type == ListWorkspaces.mine,
              type == ListWorkspaces.shared
            ],
            onPressed: (int index) {
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
            },
            borderRadius: BorderRadius.circular(8.0),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 100.0,
            ),
            children: [
              Text("Mis espacios"),
              Text("Compartidos"),
            ],
          ),
          _mainContent(context, screenSize, maxWidth, crossAxisCount, gap),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: gap,
      children: [
        Sidebar(
          title: "Tipos de espacios",
          screenSize: screenSize,
          children: [
            SidebarItem(
              title: "Mis espacios",
              leading: const Icon(Icons.home_outlined),
              leadingSelected: const Icon(Icons.home),
              isSelected: type == ListWorkspaces.mine,
              onTap: () {
                context.goNamed(
                  Routes.listWorkspace.name,
                  pathParameters: {
                    "type": ListWorkspaces.mine.name,
                  },
                );
              },
            ),
            SidebarItem(
              title: "Compartidos",
              leading: const Icon(Icons.share_outlined),
              leadingSelected: const Icon(Icons.share),
              isSelected: type == ListWorkspaces.shared,
              onTap: () {
                context.goNamed(
                  Routes.listWorkspace.name,
                  pathParameters: {
                    "type": ListWorkspaces.shared.name,
                  },
                );
              },
            ),
          ],
        ),
        _mainContent(context, screenSize, maxWidth, crossAxisCount, gap),
      ],
    );
  }

  Widget _mainContent(BuildContext context, ScreenSize screenSize,
      double maxWidth, int crossAxisCount, double gap) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          spacing: 10,
          children: [
            ButtonActions(
              title: type == ListWorkspaces.mine
                  ? "Mis espacios de trabajo"
                  : "Espacios de trabajo compartidos",
              actions: [
                if (type == ListWorkspaces.mine)
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Agregar espacio de trabajo");
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Agregar"),
                  )
              ],
              screenSize: screenSize,
            ),
            _gridBuilder(
              context,
              maxWidth,
              crossAxisCount,
              gap,
            ),
          ],
        ),
      ),
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

  Widget _gridBuilder(
    BuildContext context,
    double maxWidth,
    int crossAxisCount,
    double gap,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: crossAxisCount, // 4 cards per row
          childAspectRatio: 1 / 0.6, // Width to height ratio
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: type == ListWorkspaces.mine
              ? _getWorkspacesCard(context)
              : _getWorkspacesSharedCard(context),
        ),
      ),
    );
  }
}
