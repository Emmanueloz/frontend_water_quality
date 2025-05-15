import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  const ViewWorkspace({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Workspaces - $id",
      builder: (context, screenSize) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  SideBarItem(title: "Medidor 1"),
                  SideBarItem(title: "Medidor 2"),
                ],
              ),
            ),

            // Main content area with workspace grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white70,
                child: Center(
                  child: Text(
                    "Medidor 1",
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
