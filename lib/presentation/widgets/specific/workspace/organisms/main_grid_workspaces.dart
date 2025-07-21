import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
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
    EdgeInsetsGeometry margin;

    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);
    } else {
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
              "Espacios de trabajo",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              if (type == ListWorkspaces.mine)
                ElevatedButton.icon(
                  onPressed: () {
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
          else if (children.isEmpty)
            Center(
              child: Text(
                "No hay espacios de trabajo ${type == ListWorkspaces.mine ? 'creados' : 'compartidos'}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            GridItemBuilder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
              screenSize: screenSize,
            ),
        ],
      ),
    );
  }
}
