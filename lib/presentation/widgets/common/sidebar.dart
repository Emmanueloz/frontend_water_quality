import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';

class Sidebar extends StatelessWidget {
  final String title;
  final ScreenSize screenSize;
  final List<Widget> children;
  const Sidebar({
    super.key,
    required this.title,
    required this.screenSize,
    required this.children,
  });

  List<Widget> _buildSidebar(BuildContext context) {
    return [
      ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      ...children,
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize == ScreenSize.smallDesktop ? 200 : 300;

    return BaseContainer(
      width: width,
      height: double.infinity,
      child: ListView(
        children: _buildSidebar(context),
      ),
    );
  }
}
