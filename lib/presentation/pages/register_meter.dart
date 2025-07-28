import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/infrastructure/meter_repo_impl.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_meters.dart'; // Asegúrate de importar tu repositorio

class RegisterMeterPage extends StatefulWidget {
  final String idWorkspace;
  final String? idMeter;

  const RegisterMeterPage({super.key, required this.idWorkspace, this.idMeter});

  @override
  State<RegisterMeterPage> createState() => _RegisterMeterPageState();
}

class _RegisterMeterPageState extends State<RegisterMeterPage> {
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleSave(Meter meter) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Aquí debes llamar al repositorio que guarda el medidor
      final MeterRepo repo = MeterRepoImpl(
        Dio(),
      ); // Asegúrate que esta clase exista
      await repo.add(widget.idWorkspace, meter);

      // Si todo sale bien, puedes navegar o mostrar un mensaje
      if (mounted) {
        Navigator.pop(context, true); // Retorna a la vista anterior con éxito
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al guardar el medidor';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormMeters(
      idWorkspace: widget.idWorkspace,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onSave: _handleSave,
    );
  }
}
