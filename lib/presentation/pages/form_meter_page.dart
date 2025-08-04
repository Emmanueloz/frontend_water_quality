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

class FormMeterPage extends StatelessWidget {
  final String idWorkspace;
  final String? idMeter;

  const FormMeterPage({
    super.key,
    required this.idWorkspace,
    this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    String title = idMeter != null ? "Editar medidor" : "Crear medidor";
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    if (idMeter == null) {
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
      margin: EdgeInsets.all(idMeter != null ? 0 : 10),
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
          if (idMeter == null) {
            meterProvider.clearCurrentMeter();
          }
          return FormMeters(
            title: title,
            idWorkspace: idWorkspace,
            idMeter: idMeter,
            name: meterProvider.currentMeter?.name,
            lat: meterProvider.currentMeter?.location.lat,
            lng: meterProvider.currentMeter?.location.lon,
            placeName: null, // El modelo Meter no tiene placeName
            errorMessage: meterProvider.errorMessageForm ?? "",
            isLoading: meterProvider.isLoadingForm,
            onSave: (Meter meter) async {
              print(meter.toJson());

              if (idMeter != null) {
                print("Actualizando medidor");
                await meterProvider.updateWorkspace(idWorkspace, meter);
              } else {
                if (await meterProvider.createMeter(idWorkspace, meter) &&
                    context.mounted) {
                  context.pop();
                }
              }
            },
          );
        },
      ),
    );
  }
}
