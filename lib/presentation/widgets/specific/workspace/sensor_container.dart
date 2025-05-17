import 'package:flutter/material.dart';

class SensorContainer extends StatelessWidget {
  final Widget child;
  const SensorContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 211, 211, 211),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }
}
