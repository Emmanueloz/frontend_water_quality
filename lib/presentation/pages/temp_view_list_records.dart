import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/temp_main_listrecords.dart';

class TempViewListRecords extends StatelessWidget {
  final String id;
  final String idMeter;
  const TempViewListRecords({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return TempMainListrecords(
      id: id,
      idMeter: idMeter,
      screenSize: screenSize,
    );
  }
}
