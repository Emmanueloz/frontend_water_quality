import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/meter_ubication.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/main_map_ubications.dart';

class ViewMeterUbications extends StatelessWidget {
  final String id;
  const ViewMeterUbications({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return MainMapUbications(
      screenSize: screenSize,
      ubications: [
        // Example ubications, replace with actual data
        MeterUbication(
            name: "Medidor 1",
            latitude: 16.896614995293795,
            longitude: -92.06757293190135),
        MeterUbication(
            name: "Medidor 2",
            latitude: 16.742692572358138,
            longitude: -92.65357023705555),
        MeterUbication(
            name: "Medidor 3",
            latitude: 16.747528402130893,
            longitude: -93.06934757476262),
      ],
    );
  }
}
