import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/app_bar_navigation.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget? body;
  final Widget Function(BuildContext context, ScreenSize screenSize)? builder;

  const Layout({
    super.key,
    required this.title,
    this.body,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      ScreenSize screenSize = ResponsiveScreenSize.getScreenSize(context);

      if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: builder!(context, screenSize),
          backgroundColor: Colors.white70,
        );
      }

      return Scaffold(
        appBar: AppBarNavigation(title: title),
        body: builder!(context, screenSize),
        backgroundColor: Colors.white70,
      );
    }

    return Scaffold(
      appBar: AppBarNavigation(title: title),
      body: body,
      backgroundColor: Colors.white70,
    );
  }
}
