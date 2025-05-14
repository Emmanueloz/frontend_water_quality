import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';

class ListWorkspace extends StatelessWidget {
  const ListWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Workspaces",
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1000,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(179, 211, 211, 211),
              borderRadius: BorderRadius.circular(10.0),
            ),
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
        ],
      ),
    );
  }
}
