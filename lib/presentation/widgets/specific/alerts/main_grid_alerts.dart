import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/alert_item.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/alert_card.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/alert_tile.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/button_actions.dart';

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
    if (screenSize == ScreenSize.smallDesktop ||
        screenSize == ScreenSize.largeDesktop) {
      return Expanded(
        child: _buildMain(context),
      );
    }

    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    int crossAxisCount;
    double childAspectRatio;
    double maxWidth;
    double gap;
    EdgeInsetsGeometry margin;

    if (screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      maxWidth = double.infinity;
      childAspectRatio = 1 / 0.25;
      gap = 5;
      margin = const EdgeInsets.all(10);
    } else if (screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
      maxWidth = double.infinity;
      gap = 5;
      childAspectRatio = 1 / 0.45;
      margin = const EdgeInsets.all(10);
    } else if (screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
      maxWidth = 800;
      gap = 10;
      childAspectRatio = 1 / 0.85;
      margin = const EdgeInsets.all(0);
    } else {
      crossAxisCount = 4;
      maxWidth = 1000;
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
          _gridBuilder(
            context,
            maxWidth,
            crossAxisCount,
            childAspectRatio,
            gap,
          ),
        ],
      ),
    );
  }

  Widget _gridBuilder(
    BuildContext context,
    double maxWidth,
    int crossAxisCount,
    double childAspectRatio,
    double gap,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: crossAxisCount, // 4 cards per row
          childAspectRatio: childAspectRatio, // Width to height ratio
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: screenSize == ScreenSize.mobile ? _buildTileAlerts() : _buildCardAlerts(),
        ),
      ),
    );
  }

  List<AlertCard> _buildCardAlerts() {
    return alertItems.map((AlertItem item) {
      return AlertCard(title: item.title, type: item.type);
    }).toList();
  }

  List<AlertTile> _buildTileAlerts() {
    return alertItems.map((AlertItem item) {
      return AlertTile(title: item.title, type: item.type);
    }).toList();
  }
}
