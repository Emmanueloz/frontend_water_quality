import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/grid_workspaces.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainGridWorkspaces extends StatelessWidget {
  final ListWorkspaces type;
  final ScreenSize screenSize;
  final List<Widget> children;
  final bool isLoading;

  const MainGridWorkspaces({
    super.key,
    required this.type,
    required this.screenSize,
    required this.children,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    int crossAxisCount;
    double childAspectRatio;
    double gap;
    EdgeInsetsGeometry margin;

    if (screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      childAspectRatio = 1 / 0.6;
      gap = 5;
      margin = const EdgeInsets.all(10);
    } else if (screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
      gap = 5;
      childAspectRatio = 1 / 0.6;
      margin = const EdgeInsets.all(10);
    } else if (screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
      gap = 10;
      childAspectRatio = 1 / 0.85;
      margin = const EdgeInsets.all(0);
    } else {
      crossAxisCount = 4;
      gap = 16;
      childAspectRatio = 1 / 0.85;
      margin = const EdgeInsets.all(0);
    }
    return BaseContainer(
      margin: margin,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 10,
        children: [
          ButtonActions(
            title: Text(
              type == ListWorkspaces.mine
                  ? "Mis espacios de trabajo"
                  : "Espacios de trabajo",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              if (type == ListWorkspaces.mine)
                ElevatedButton.icon(
                  onPressed: () {
                    print("Agregar espacio de trabajo");
                    context.goNamed(
                      Routes.createWorkspace.name,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar"),
                )
            ],
            screenSize: screenSize,
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            GridWorkspaces(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              gap: gap,
              children: children,
            ),
        ],
      ),
    );
  }
}
