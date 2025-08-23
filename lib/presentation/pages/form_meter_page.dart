import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
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
  bool isLoading = false;
  String? errorMessage;

  Future<void> _handleSave(BuildContext context, Meter meter) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final provider = Provider.of<MeterProvider>(context, listen: false);
    final errorMSG = widget.idMeter != null
        ? await provider.updateMeter(widget.idWorkspace, meter)
        : await provider.createMeter(widget.idWorkspace, meter);

    setState(() {
      isLoading = false;
      errorMessage = errorMSG;
    });

    if (errorMSG == null && context.mounted) {
      context.pop();
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
        margin: EdgeInsets.all(10),
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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Consumer<MeterProvider>(
        builder: (context, meterProvider, child) {
          return FormMeters(
            title: title,
            idWorkspace: widget.idWorkspace,
            idMeter: widget.idMeter,
            errorMessage: errorMessage ?? "",
            isLoading: isLoading,
            onSave: (Meter meter) async {
              await _handleSave(context, meter);
            },
          );
        },
      ),
    );
  }
}
