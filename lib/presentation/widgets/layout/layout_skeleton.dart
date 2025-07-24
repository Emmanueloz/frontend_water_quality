import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class LayoutSkeleton extends StatelessWidget {
  const LayoutSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Cargando...",
      selectedIndex: 0,
      onDestinationSelected: (index) {},
      destinations: [
        NavigationItem(
          label: "Cargando...",
          icon: Icons.hourglass_empty,
          selectedIcon: Icons.hourglass_top,
        ),
        NavigationItem(
          label: "Cargando...",
          icon: Icons.hourglass_empty,
          selectedIcon: Icons.hourglass_top,
        ),
        NavigationItem(
          label: "Cargando...",
          icon: Icons.hourglass_empty,
          selectedIcon: Icons.hourglass_top,
        ),
        NavigationItem(
          label: "Cargando...",
          icon: Icons.hourglass_empty,
          selectedIcon: Icons.hourglass_top,
        ),
        NavigationItem(
          label: "Cargando...",
          icon: Icons.hourglass_empty,
          selectedIcon: Icons.hourglass_top,
        ),
      ],
      builder: (context, screenSize) {
        return BaseContainer(
          margin:
              screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
                  ? const EdgeInsets.all(10)
                  : null,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
