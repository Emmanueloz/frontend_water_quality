import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/common/app_bar_navigation.dart';
import 'package:frontend_water_quality/presentation/widgets/common/drawer_navigation.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget? body;
  final List<Widget>? childrenDrawer;
  final int? selectedIndex;
  final List<NavigationItem>? destinations;
  final void Function(int)? onDestinationSelected;
  final Widget Function(BuildContext context, ScreenSize screenSize)? builder;

  const Layout({
    super.key,
    required this.title,
    this.body,
    this.builder,
    this.childrenDrawer,
    this.selectedIndex,
    this.destinations,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      ScreenSize screenSize = ResponsiveScreenSize.getScreenSize(context);

      bool showNavigationBar = selectedIndex != null && destinations != null;

      if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          drawer: DrawerNavigation(title: title, children: childrenDrawer),
          body: builder!(context, screenSize),
          bottomNavigationBar: showNavigationBar
              ? NavigationBar(
                  selectedIndex: selectedIndex ?? 0,
                  destinations: destinations!
                      .map(
                        (NavigationItem item) => NavigationDestination(
                          label: item.label,
                          icon: Icon(
                            item.icon,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          selectedIcon: Icon(
                            item.selectedIcon,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                      .toList(),
                  onDestinationSelected: onDestinationSelected,
                )
              : null,
        );
      }
      if (showNavigationBar) {
        return buildWithNavigationBar(context, screenSize);
      }

      return Scaffold(
        appBar: AppBarNavigation(title: title),
        body: builder!(context, screenSize),
      );
    }

    return Scaffold(
      appBar: AppBarNavigation(title: title),
      body: body,
    );
  }

  Widget buildWithNavigationBar(BuildContext context, ScreenSize screenSize) {
    return Scaffold(
      appBar: AppBarNavigation(title: title),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Sidebar(
              screenSize: screenSize,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations!
                  .map(
                    (NavigationItem item) => NavigationRailDestination(
                      label: Text(item.label),
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                    ),
                  )
                  .toList(),
            ),
            builder!(context, screenSize),
          ],
        ),
      ),
    );
  }
}
