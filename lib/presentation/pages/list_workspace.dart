import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';

class ListWorkspace extends StatelessWidget {
  const ListWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Workspaces",
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar with workspace list
          Container(
            margin: const EdgeInsets.all(16.0),
            width: 300, // Fixed width for sidebar
            height: double.infinity, // Take full height
            decoration: BoxDecoration(
              color: const Color.fromARGB(179, 211, 211, 211),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: const [
                SideBarItem(title: "Workspace 1"),
                SideBarItem(title: "Workspace 2"),
              ],
            ),
          ),

          // Main content area with workspace grid
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white70,
              child: GridView.count(
                crossAxisCount: 4, // 4 cards per row
                childAspectRatio: 1.2, // Width to height ratio
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: const [
                  WorkspaceCard(
                    id: "1",
                    title: "Workspace 1",
                    subtitle: "Subtitle 1",
                  ),
                  WorkspaceCard(
                    id: "2",
                    title: "Workspace 2",
                    subtitle: "Subtitle 2",
                  ),
                  WorkspaceCard(
                    id: "3",
                    title: "Workspace 3",
                    subtitle: "Subtitle 3",
                  ),
                  WorkspaceCard(
                    id: "4",
                    title: "Workspace 4",
                    subtitle: "Subtitle 4",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
