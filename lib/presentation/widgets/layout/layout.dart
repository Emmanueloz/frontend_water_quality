import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/app_bar_mobile.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/app_bar_navigation.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/drawer_navigation.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:provider/provider.dart';

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
    // Si no hay builder personalizado, usar layout básico
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    final hasNavigation = _hasNavigationData();

    // Layout para dispositivos móviles y tablets
    if (_isMobileOrTablet(screenSize)) {
      return _buildMobileLayout(context, screenSize, hasNavigation);
    }

    // Layout para desktop
    return hasNavigation
        ? _buildDesktopWithNavigation(context, screenSize)
        : _buildDesktopLayout(context, screenSize);
  }

  /// Verifica si tiene datos de navegación válidos
  bool _hasNavigationData() {
    return selectedIndex != null && destinations != null;
  }

  /// Verifica si es dispositivo móvil o tablet
  bool _isMobileOrTablet(ScreenSize screenSize) {
    return screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;
  }

  /// Layout para dispositivos móviles y tablets
  Widget _buildMobileLayout(
      BuildContext context, ScreenSize screenSize, bool hasNavigation) {
    return Scaffold(
      appBar: AppBarMobile(title: title),
      endDrawer:
          Provider.of<AuthProvider>(context, listen: false).isAuthenticated
              ? _buildDrawer()
              : null,
      body: builder != null ? builder!(context, screenSize) : body,
      bottomNavigationBar:
          hasNavigation ? _buildBottomNavigationBar(context, screenSize) : null,
    );
  }

  /// Layout para desktop sin navegación
  Widget _buildDesktopLayout(BuildContext context, ScreenSize screenSize) {
    return Scaffold(
      appBar: AppBarNavigation(title: title),
      body: builder != null ? builder!(context, screenSize) : body,
    );
  }

  /// Layout para desktop con navegación lateral
  Widget _buildDesktopWithNavigation(
      BuildContext context, ScreenSize screenSize) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(screenSize),
          Expanded(
            child: Column(
              children: [
                AppBarNavigation(
                  title: title,
                ),
                Expanded(
                    child: builder != null
                        ? builder!(context, screenSize)
                        : body!),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Construye el drawer de navegación
  Widget? _buildDrawer() {
    return DrawerNavigation(
      title: title,
      children: childrenDrawer,
    );
  }

  /// Construye la barra de navegación inferior
  Widget? _buildBottomNavigationBar(
      BuildContext context, ScreenSize screenSize) {
    NavigationDestinationLabelBehavior labelBehavior =
        screenSize == ScreenSize.mobile
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow;

    final destinations = _buildNavigationDestinations(context);

    if (destinations.isEmpty || destinations.length <= 1) {
      return null;
    }

    return NavigationBar(
      selectedIndex: selectedIndex ?? 0,
      labelBehavior: labelBehavior,
      destinations: destinations,
      onDestinationSelected: onDestinationSelected,
    );
  }

  /// Construye la barra lateral de navegación
  Widget _buildSidebar(ScreenSize screenSize) {
    return Sidebar(
      screenSize: screenSize,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _buildNavigationRailDestinations(),
    );
  }

  /// Construye las destinations para NavigationBar
  List<NavigationDestination> _buildNavigationDestinations(
      BuildContext context) {
    return destinations!.map((NavigationItem item) {
      return NavigationDestination(
        label: item.label,
        icon: Icon(
          item.icon,
        ),
        selectedIcon: Icon(
          item.selectedIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }).toList();
  }

  /// Construye las destinations para NavigationRail
  List<NavigationRailDestination> _buildNavigationRailDestinations() {
    return destinations!.map((NavigationItem item) {
      return NavigationRailDestination(
        label: Text(item.label),
        icon: Icon(item.icon),
        selectedIcon: Icon(item.selectedIcon),
      );
    }).toList();
  }
}
