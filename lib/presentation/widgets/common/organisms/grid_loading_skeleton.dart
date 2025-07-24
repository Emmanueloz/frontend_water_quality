import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class GridLoadingSkeleton extends StatefulWidget {
  final ScreenSize screenSize;
  const GridLoadingSkeleton({
    super.key,
    required this.screenSize,
  });

  @override
  State<GridLoadingSkeleton> createState() => _GridLoadingSkeletonState();
}

class _GridLoadingSkeletonState extends State<GridLoadingSkeleton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;
    double childAspectRatio;
    double gap;

    if (widget.screenSize == ScreenSize.mobile) {
      crossAxisCount = 1;
      childAspectRatio = 1 / 0.6;
      gap = 5;
    } else if (widget.screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
      gap = 5;
      childAspectRatio = 1 / 0.6;
    } else if (widget.screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
      gap = 10;
      childAspectRatio = 1 / 0.85;
    } else {
      crossAxisCount = 4;
      gap = 16;
      childAspectRatio = 1 / 0.85;
    }

    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          children: List.generate(8, (index) {
            // Desfase para cada ítem
            return AnimatedBuilder(
              animation: _controller,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              builder: (context, child) {
                return Opacity(
                  opacity: Tween<double>(
                    begin: 0.4,
                    end: 1,
                  ).transform(_controller.value),
                  child: child,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
