import 'package:flutter/material.dart';

import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/meter_card.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_workspace.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListMeter extends StatefulWidget {
  final String idWorkspace;
  const ListMeter({super.key, required this.idWorkspace});

  @override
  State<ListMeter> createState() => _ListMeterState();
}

class _ListMeterState extends State<ListMeter> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeterProvider>(context, listen: false)
          .fetchMeters(widget.idWorkspace);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        return MainWorkspace(
          id: widget.idWorkspace,
          screenSize: screenSize,
          isLoading: meterProvider.isLoading,
          errorMessage: meterProvider.errorMessage,
          itemCount: meterProvider.meters.length,
          itemBuilder: (context, index) {
            final meter = meterProvider.meters[index];
            
            return MeterCard(
              id: meter.id ?? '',
              name: meter.name,
              state: meter.state ?? 'disconnected',
              location: meter.location,
              onTap: () {
                context.goNamed(
                  Routes.meter.name,
                  pathParameters: {
                    'id': widget.idWorkspace,
                    'idMeter': meter.id ?? '',
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
