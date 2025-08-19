import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/alert_item.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/alert_card.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/alert_tile.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';

class MainGridAlerts extends StatelessWidget {
  final ScreenSize screenSize;
  final List<AlertItem> alertItems;
  const MainGridAlerts({
    super.key,
    required this.screenSize,
    required this.alertItems,
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
              "Alertas",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  print("Agregar alerta");
                },
                icon: const Icon(Icons.add),
                label: const Text("Agregar"),
              )
            ],
            screenSize: screenSize,
          ),
          GridItemBuilder(
            itemCount: alertItems.length,
            itemBuilder: (context, index) {
              final item = alertItems[index];
              return screenSize == ScreenSize.mobile
                  ? AlertTile(title: item.title, type: item.type)
                  : AlertCard(title: item.title, type: item.type);
            },
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }
}
