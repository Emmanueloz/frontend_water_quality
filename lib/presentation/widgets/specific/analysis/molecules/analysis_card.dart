import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class AnalysisCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final void Function()? onTab;
  final ScreenSize screenSize;

  const AnalysisCard({
    super.key,
    required this.title,
    this.icon,
    this.onTab,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTab,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: _getIconSize(),
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getIconSize() {
    switch (screenSize) {
      case ScreenSize.mobile:
        return 40;
      case ScreenSize.tablet:
        return 60;
      case ScreenSize.smallDesktop:
        return 80;
      case ScreenSize.largeDesktop:
        return 100;
    }
  }
}
