import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';

class ViewMeterConnection extends StatelessWidget {
  final String title;
  final String id;
  final String idMeter;

  const ViewMeterConnection(
      {super.key,
      required this.title,
      required this.id,
      required this.idMeter});

  @override
  Widget build(BuildContext context) {
    return LayoutMeters(
        title: title,
        id: id,
        idMeter: idMeter,
        selectedIndex: 4,
        builder: builder);
  }
}
