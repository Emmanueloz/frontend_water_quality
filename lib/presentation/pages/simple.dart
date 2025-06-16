import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class Simple extends StatelessWidget {
  final String title;
  const Simple({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) => Column(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
