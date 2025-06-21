import 'package:flutter/material.dart';

class SensorContainer extends StatelessWidget {
  final Widget child;
  const SensorContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }
}
