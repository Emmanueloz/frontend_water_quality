import 'package:flutter/material.dart';

class SideBarItem extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget leadingSelected;
  final bool isSelected;
  final void Function()? onTap;

  const SideBarItem({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
    required this.leading,
    required this.leadingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelected ? leadingSelected : leading,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      selected: isSelected,
      selectedColor: Colors.black,
      selectedTileColor: Colors.cyan.shade100,
      onTap: onTap,
    );
  }
}
