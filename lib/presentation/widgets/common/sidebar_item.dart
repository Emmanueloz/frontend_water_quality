import 'package:flutter/material.dart';

class SideBarItem extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const SideBarItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
