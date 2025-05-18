import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';

class Sidebar extends StatelessWidget {
  final String title;
  final ScreenSize screenSize;
  final List<SidebarItem> children;
  const Sidebar({
    super.key,
    required this.title,
    required this.screenSize,
    required this.children,
  });

  List<Widget> _buildSidebar(BuildContext context) {
    return [
      ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ...children,
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize == ScreenSize.smallDesktop ? 200 : 300;

    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 211, 211, 211),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView(
        children: _buildSidebar(context),
      ),
    );
  }
}
