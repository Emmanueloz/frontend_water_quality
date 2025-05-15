import 'package:flutter/material.dart';

class SideBarItem extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const SideBarItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.analytics_outlined),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
