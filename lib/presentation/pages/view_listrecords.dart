import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_listrecords.dart';

class VieListrecords extends StatelessWidget {
  final String id;
  const VieListrecords({super.key, required this.id});

  @override
  Widget build(BuildContext context) {

    return Layout(
      title: "Medidor $id",
      builder: (context, screenSize) {
        return MainListrecords(
          id: id,
          idMeter: "1",
          screenSize: screenSize,
        );
      },
    );
  }
}
