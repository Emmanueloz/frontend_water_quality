import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class EmptyAnalysis extends StatelessWidget {
  const EmptyAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 60,
          ),
          Text(
            "Selecciona una estadistica de la tabla",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }
}
