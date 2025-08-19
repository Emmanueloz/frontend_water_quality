import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class GridItemBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScreenSize screenSize;
  const GridItemBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;
    double childAspectRatio;
    double gap;

    if (screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      childAspectRatio = 1 / 0.6;
      gap = 5;
    } else if (screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
      gap = 5;
      childAspectRatio = 1 / 0.6;
    } else if (screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
      gap = 10;
      childAspectRatio = 1 / 0.85;
    } else {
      crossAxisCount = 4;
      gap = 16;
      childAspectRatio = 1 / 0.85;
    }
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
