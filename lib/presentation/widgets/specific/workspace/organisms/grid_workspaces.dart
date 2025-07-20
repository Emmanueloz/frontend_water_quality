import 'package:flutter/material.dart';

class GridWorkspaces extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double gap;
  final List<Widget> children;
  const GridWorkspaces({
    super.key,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.gap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: crossAxisCount, // 4 cards per row
          childAspectRatio: childAspectRatio, // Width to height ratio
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        ),
      ),
    );
  }
}
