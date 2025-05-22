import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/button_actions.dart';

class MainGridWorkspaces extends StatelessWidget {
  final ListWorkspaces type;
  final ScreenSize screenSize;
  final List<Widget> children;
  const MainGridWorkspaces({
    super.key,
    required this.type,
    required this.screenSize,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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

    return Expanded(
      child: BaseContainer(
        padding: const EdgeInsets.all(16.0),
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
          children: children,
        ),
      ),
    );
  }
}
