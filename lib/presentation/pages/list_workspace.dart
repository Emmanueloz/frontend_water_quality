import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/workspace_card.dart';

class ListWorkspace extends StatelessWidget {
  const ListWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacios de trabajo",
      builder: (context, screenSize) {
        print("screenSize: $screenSize");

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainContent(context, screenSize),
          ],
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
      return Expanded(
        child: Container(
          width: maxWidth,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(179, 211, 211, 211),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: _gridBuilder(
            context,
            maxWidth,
            crossAxisCount,
            gap,
          ),
        ),
      );
    }

    return Container(
      width: maxWidth,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 211, 211, 211),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: _gridBuilder(
        context,
        maxWidth,
        crossAxisCount,
        gap,
      ),
    );
  }

  Widget _gridBuilder(
    BuildContext context,
    double maxWidth,
    int crossAxisCount,
    double gap,
  ) {
    return GridView.count(
      crossAxisCount: crossAxisCount, // 4 cards per row
      childAspectRatio: 1.2, // Width to height ratio
      crossAxisSpacing: gap,
      mainAxisSpacing: gap,
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
    );
  }
}
