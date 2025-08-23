import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_meters.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormMeterPage extends StatefulWidget {
  final String idWorkspace;
  final String? idMeter;

  const FormMeterPage({
    super.key,
    required this.idWorkspace,
    this.idMeter,
  });

  @override
  State<FormMeterPage> createState() => _FormMeterPageState();
}

class _FormMeterPageState extends State<FormMeterPage> {
  late Future<Result<Meter>>? _meterFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.idMeter != null) {
      _meterFuture = _fetchMeter();
    }
  }

  Future<Result<Meter>> _fetchMeter() async {
    final provider = context.read<MeterProvider>();
    return await provider.getMeterById(widget.idWorkspace, widget.idMeter!);
  }

  Future<void> _handleSubmit(BuildContext context, Meter meter) async {
    setState(() => _isLoading = true);

    final provider = context.read<MeterProvider>();
    String? error;

    if (widget.idMeter != null) {
      error = await provider.updateMeter(widget.idWorkspace, meter);
      print("Error updating meter: $error");
    } else {
      error = await provider.createMeter(widget.idWorkspace, meter);
      print("Error creating meter: $error");
    }

    if (mounted) {
      setState(() => _isLoading = false);

      print(error);

      if (error == null && context.mounted && widget.idMeter != null) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.idMeter != null ? "Editar medidor" : "Crear medidor";
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    if (widget.idMeter == null) {
      return Layout(
        title: title,
        builder: (context, screenSize) {
          return _builderMain(context, screenSize, title);
        },
      );
    }

    return _builderMain(context, screenSize, title);
  }

  Widget _builderMain(
      BuildContext context, ScreenSize screenSize, String title) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize, title),
      );
    }

    return BaseContainer(
      margin: EdgeInsets.all(widget.idMeter != null ? 0 : 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize, title),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize, String title) {
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: widget.idMeter != null
          ? FutureBuilder<Result<Meter>>(
              future: _meterFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!.isSuccess) {
                  return Center(
                    child: Text(
                      snapshot.data?.message ?? 'Error cargando medidor',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final meter = snapshot.data!.value!;
                return FormMeters(
                  title: title,
                  idWorkspace: widget.idWorkspace,
                  idMeter: widget.idMeter,
                  name: meter.name,
                  lat: meter.location.lat,
                  lng: meter.location.lon,
                  isLoading: _isLoading,
                  errorMessage: snapshot.data?.message ?? "",
                  onSave: (meter) => _handleSubmit(context, meter),
                );
              },
            )
          : FormMeters(
              title: title,
              idWorkspace: widget.idWorkspace,
              isLoading: _isLoading,
              errorMessage: "",
              onSave: (meter) => _handleSubmit(context, meter),
            ),
    );
  }
}
