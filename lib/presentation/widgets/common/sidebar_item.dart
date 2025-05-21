import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget leadingSelected;
  final bool isSelected;
  final void Function()? onTap;

  const SidebarItem({
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
      title: Text(title),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
