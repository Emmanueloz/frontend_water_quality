import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_listrecords.dart';

class ViewListRecords extends StatelessWidget {
  final String id;
  final String idMeter;
  const ViewListRecords({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return MainListrecords(
      id: id,
      idMeter: idMeter,
      screenSize: screenSize,
    );
  }
}
