import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ResponsiveScreenSize {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double smallDesktop = 1200;

  static ScreenSize getScreenSize(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;

    if (width < mobile) {
      return ScreenSize.mobile;
    } else if (width < tablet) {
      return ScreenSize.tablet;
    } else if (width < smallDesktop) {
      return ScreenSize.smallDesktop;
    } else {
      return ScreenSize.largeDesktop;
    }
  }
}
