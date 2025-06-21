import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/meter_item.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/atoms/meter_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainWorkspace extends StatelessWidget {
  final String id;
  final ScreenSize screenSize;
  final List<MeterItem> meters;

  const MainWorkspace({
    super.key,
    required this.id,
    required this.screenSize,
    required this.meters,
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
      childAspectRatio = 1 / 0.2;
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
                children: _buildMetersItem(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMetersItem(BuildContext context) {
    if (screenSize == ScreenSize.mobile) {
      return meters.map((meter) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(
              meter.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Chip(
              label: Text(meter.state.name),
            ),
            onTap: () {
              context.goNamed(
                Routes.meter.name,
                pathParameters: {
                  "id": id,
                  "idMeter": meter.id,
                },
              );
            },
          ),
        );
      }).toList();
    }

    return meters.map((meter) {
      return MeterCard(
        id: meter.id,
        name: meter.name,
        state: meter.state,
        onTap: () {
          context.goNamed(
            Routes.meter.name,
            pathParameters: {
              "id": id,
              "idMeter": meter.id,
            },
          );
        },
      );
    }).toList();
  }
}
