import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class Sidebar extends StatelessWidget {
  final ScreenSize screenSize;
  final List<Widget>? children;
  final List<NavigationRailDestination>? destinations;
  final int? selectedIndex;
  final void Function(int)? onDestinationSelected;
  const Sidebar({
    super.key,
    required this.screenSize,
    this.destinations,
    this.children,
    this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isExtended = screenSize == ScreenSize.largeDesktop;

    return BaseContainer(
      padding: const EdgeInsets.all(5),
      child: NavigationRail(
        extended: isExtended,
        selectedIndex: selectedIndex,
        minExtendedWidth: 200,
        destinations: destinations ?? [],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
