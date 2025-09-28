import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

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

    return NavigationRail(
      extended: isExtended,
      selectedIndex: selectedIndex,
      minExtendedWidth: 200,
      leading: _heroWidget(context, isExtended),
      destinations: destinations ?? [],
      onDestinationSelected: onDestinationSelected,
    );
  }

  Widget _heroWidget(BuildContext context, bool isExtended) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Image.asset(
          "assets/images/icon.png",
          width: 45,
        ),
        if (isExtended)
          Text(
            "Aqua Minds",
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colorScheme.surface,
            ),
          ),
      ],
    );
  }
}
