import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/result.dart';

import 'package:frontend_water_quality/domain/models/meter_model.dart';

import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/workspace_context.dart';
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
  late Future<Result<List<Meter>>> _metersFuture;

  @override
  void initState() {
    super.initState();
    _metersFuture = _fetchMeters();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MeterProvider>(context);
    if (provider.shouldReloadList(widget.idWorkspace)) {
      setState(() {
        _metersFuture = _fetchMeters();
      });
    }
  }

  Future<Result<List<Meter>>> _fetchMeters() async {
    final provider = Provider.of<MeterProvider>(context, listen: false);
    final result = await provider.getMeters(widget.idWorkspace);
    provider.confirmListReloaded(widget.idWorkspace);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    final workspaceContext = WorkspaceContext.of(context);
    final role = workspaceContext?.workspace?.role;

    return FutureBuilder<Result<List<Meter>>>(
      future: _metersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainWorkspace(
            id: widget.idWorkspace,
            screenSize: screenSize,
            isLoading: true,
            itemCount: 0,
            itemBuilder: (_, __) => const SizedBox(),
            role: role,
          );
        }

        if (snapshot.hasError || snapshot.data?.message != null) {
          return MainWorkspace(
            id: widget.idWorkspace,
            screenSize: screenSize,
            isLoading: false,
            errorMessage: snapshot.data?.message ?? 'Error loading meters',
            itemCount: 0,
            itemBuilder: (_, __) => const SizedBox(),
            role: role,
          );
        }

        final meters = snapshot.data!.value ?? [];

        return MainWorkspace(
          id: widget.idWorkspace,
          screenSize: screenSize,
          isLoading: false,
          itemCount: meters.length,
          role: role,
          onRefresh: () {
            final provider = context.read<MeterProvider>();
            provider.markListForReload(widget.idWorkspace);
            setState(() {
              _metersFuture = _fetchMeters();
            });
          },
          itemBuilder: (context, index) {
            final meter = meters[index];
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
