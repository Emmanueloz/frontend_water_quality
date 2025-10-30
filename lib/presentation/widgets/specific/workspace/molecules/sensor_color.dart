import 'package:flutter/material.dart';

class SensorColor extends StatelessWidget {
  final int red;
  final int green;
  final int blue;
  const SensorColor({
    super.key,
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.shadow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            "Color del agua",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(
                  red,
                  green,
                  blue,
                  1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
