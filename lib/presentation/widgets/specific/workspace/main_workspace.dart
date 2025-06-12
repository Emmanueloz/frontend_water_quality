import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/meter_state.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/meter_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainWorkspace extends StatelessWidget {
  final String id;
  final ListWorkspaces type;
  final ScreenSize screenSize;

  const MainWorkspace({
    super.key,
    required this.id,
    required this.screenSize,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (screenSize == ScreenSize.smallDesktop ||
        screenSize == ScreenSize.largeDesktop) {
      return Expanded(child: _buildMain(context));
    }

    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    int crossAxisCount;
    double childAspectRatio;
    double gap;
    EdgeInsetsGeometry margin;

    if (screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      childAspectRatio = 1 / 0.4;
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
      childAspectRatio = 1 / 0.6;
      margin = const EdgeInsets.all(0);
    } else {
      crossAxisCount = 4;
      gap = 16;
      childAspectRatio = 1 / 0.6;
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
              "Espacio de trabajo $id",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Agregar"),
              )
            ],
            screenSize: screenSize,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: gap,
                mainAxisSpacing: gap,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MeterCard(
                    id: "1",
                    name: "Medidor 1",
                    state: MeterState.connected,
                    onTap: () {
                      context.goNamed(
                        Routes.meter.name,
                        pathParameters: {
                          "id": id,
                          "idMeter": "1",
                          "type": type.name,
                        },
                      );
                    },
                  ),
                  MeterCard(
                    id: "2",
                    name: "Medidor 2",
                    state: MeterState.sendingData,
                  ),
                  MeterCard(
                    id: "3",
                    name: "Medidor 3",
                    state: MeterState.disconnected,
                  ),
                  MeterCard(
                    id: "3",
                    name: "Medidor 3",
                    state: MeterState.disconnected,
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
