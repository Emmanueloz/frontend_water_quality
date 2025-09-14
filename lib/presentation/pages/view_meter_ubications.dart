import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/meter_ubication.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/main_map_ubications.dart';
import 'package:provider/provider.dart';

class ViewMeterUbications extends StatefulWidget {
  final String idWorkspace;
  const ViewMeterUbications({super.key, required this.idWorkspace});

  @override
  State<ViewMeterUbications> createState() => _ViewMeterUbicationsState();
}

class _ViewMeterUbicationsState extends State<ViewMeterUbications> {
  late Future<Result<List<Meter>>> _metersFuture;

  @override
  void initState() {
    super.initState();
    _metersFuture = _fetchMeters();
  }

  Future<Result<List<Meter>>> _fetchMeters() async {
    final provider = Provider.of<MeterProvider>(context, listen: false);
    final result = await provider.getMeters(widget.idWorkspace);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return FutureBuilder<Result<List<Meter>>>(
      future: _metersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data?.message != null) {
          return Center(
            child: Text(
              snapshot.data?.message ?? 'Error cargando las ubicaciones',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final meters = snapshot.data!.value ?? [];

        final ubications = meters.map((meter) {
          final name_location = meter.location.name_location;
          final lat = meter.location.lat;
          final lng = meter.location.lon;
          final state = meter.state;
           {
            return MeterUbication(
              name: meter.name,
              name_location: name_location,
              latitude: lat,
              longitude: lng,
              state: state,
            );
          }
          
        }).whereType<MeterUbication>().toList();

        return MainMapUbications(
          screenSize: screenSize,
          ubications: ubications,
        );
      },
    );
  }
}
