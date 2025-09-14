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
    return Card(
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
              height: 200,
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
