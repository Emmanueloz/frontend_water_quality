import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';

class Sidebar extends StatelessWidget {
  final String title;
  final ScreenSize screenSize;
  final List<Widget>? children;
  final List<NavigationRailDestination>? destinations;
  final int? selectedIndex;
  final void Function(int)? onDestinationSelected;
  const Sidebar({
    super.key,
    required this.title,
    required this.screenSize,
    this.destinations,
    this.children,
    this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: const EdgeInsets.all(10),
      child: NavigationRail(
        extended: screenSize == ScreenSize.largeDesktop,
        selectedIndex: selectedIndex,
        leading: Text(title),
        destinations: destinations ?? [],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
