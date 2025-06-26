import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/error_view.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/idle_view.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/password_view.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/success_view.dart';

enum ConnectionStep { idle, showPassword, success, error }

class MainMeterConnectionWidget extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  const MainMeterConnectionWidget({super.key, 
    required this.idWorkspace,
    required this.idMeter,
  });

  @override
  _MainMeterConnectionWidgetState createState() => _MainMeterConnectionWidgetState();
}

class _MainMeterConnectionWidgetState extends State<MainMeterConnectionWidget> {
  ConnectionStep _step = ConnectionStep.idle;
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _startConnection() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Llamada al backend para generar la contraseña
      await Future.delayed(const Duration(seconds: 2));
      // Simulación de posible error:
      if (DateTime.now().second % 5 == 0){
        throw Exception('Error generando contraseña');
      }
      setState(() {
        _password = List.generate(6, (_) => _randomInt()).join();
        _step = ConnectionStep.showPassword;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _step = ConnectionStep.error;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmPasswordEntered() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Poll/WebSocket para confirmar conexión
      await Future.delayed(const Duration(seconds: 2));
      // Simulación de posible error:
      if (DateTime.now().millisecond % 7 == 0){
        throw Exception('Conexión fallida en el dispositivo');
      }
      setState(() => _step = ConnectionStep.success);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _step = ConnectionStep.error;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _randomInt() {
    // Genera un número aleatorio entre 0 y 9
    return (DateTime.now().millisecond % 10).toString();
  }

  void _retry() {
    setState(() {
      _step = ConnectionStep.idle;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_step) {
      case ConnectionStep.showPassword:
        content = PasswordView(
          password: _password,
          isLoading: _isLoading,
          onContinue: _confirmPasswordEntered,
        );
        break;
      case ConnectionStep.success:
        content = SuccessView();
        break;
      case ConnectionStep.error:
        content = ErrorView(
          message: _errorMessage,
          onRetry: _retry,
        );
        break;
      case ConnectionStep.idle:
        content = IdleView(
          isLoading: _isLoading,
          onStart: _startConnection,
        );
    }

    return BaseContainer(
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
