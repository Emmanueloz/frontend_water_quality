import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class MainContent extends StatelessWidget {
  final String id;
  final String idMeter;
  const MainContent({super.key, required this.id, required this.idMeter});

  @override
  Widget build(BuildContext context) {
    return BaseContainer();
  }
}
