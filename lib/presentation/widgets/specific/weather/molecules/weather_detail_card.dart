import 'package:flutter/material.dart';

class WeatherDetailCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const WeatherDetailCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text(label),
            Text.rich(TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: unit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
