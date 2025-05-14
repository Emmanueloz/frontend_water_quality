import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/app_bar_navigation.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget body;
  const Layout({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(title: title),
      body: body,
      backgroundColor: Colors.white70,
    );
  }
}
