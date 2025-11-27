import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainGridWorkspaces extends StatelessWidget {
  final ListWorkspaces type;
  final ScreenSize screenSize;
  final bool isLoading;

  final String? errorMessage;

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function()? onRefresh;
  final Widget? paginationControls;

  const MainGridWorkspaces({
    super.key,
    required this.type,
    required this.screenSize,
    required this.isLoading,
    required this.itemCount,
    required this.itemBuilder,
    this.errorMessage,
    this.onRefresh,
    this.paginationControls,
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
              if (paginationControls != null) paginationControls!,
              IconButton(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh),
              ),
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
            GridLoadingSkeleton(screenSize: screenSize)
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else if (itemCount == 0)
            Center(
              child: Text(
                "No hay espacios de trabajo ${type == ListWorkspaces.mine ? 'creados' : type == ListWorkspaces.shared ? 'compartidos' : 'disponibles'}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            GridItemBuilder(
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              screenSize: screenSize,
            ),
        ],
      ),
    );
  }
}
