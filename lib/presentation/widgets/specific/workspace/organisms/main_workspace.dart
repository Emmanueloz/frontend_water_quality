import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainWorkspace extends StatelessWidget {
  final String id;
  final ScreenSize screenSize;
  final bool isLoading;
  final String? errorMessage;
  final int itemCount;
  final void Function()? onRefresh;

  final Widget Function(BuildContext, int) itemBuilder;

  const MainWorkspace({
    super.key,
    required this.id,
    required this.screenSize,
    this.isLoading = false,
    this.errorMessage,
    this.itemCount = 0,
    required this.itemBuilder,
    this.onRefresh,
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
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          ButtonActions(
            title: Text(
              "Medidores",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed(
                    Routes.createMeter.name,
                    pathParameters: {"id": id},
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
                "No hay medidores en este espacio de trabajo.",
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
