import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/pairing_state.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/core/errors/pairing_error.dart';

class MeterPairingStatus extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  final String? deviceToken;
  final Function(String token)? onTokenUpdated;

  const MeterPairingStatus({
    super.key,
    required this.idWorkspace,
    required this.idMeter,
    this.deviceToken,
    this.onTokenUpdated,
  });

  @override
  State<MeterPairingStatus> createState() => _MeterPairingStatusState();
}

class _MeterPairingStatusState extends State<MeterPairingStatus> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePairingContext();
    });
  }

  void _initializePairingContext() {
    if (_isInitialized) return;
    
    final blueProvider = Provider.of<BlueProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      blueProvider.setValidationContext(
        userToken: authProvider.token!,
        workspaceId: widget.idWorkspace,
        meterId: widget.idMeter,
      );
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<BlueProvider>(
      builder: (context, blueProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                'Estado de Emparejamiento',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusContent(theme, blueProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusContent(ThemeData theme, BlueProvider blueProvider) {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            _buildStatusIndicator(theme, blueProvider.pairingState),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusMessage(theme, blueProvider.pairingState, blueProvider.lastError),
            ),
          ],
        ),
        if (_shouldShowErrorDetails(blueProvider))
          _buildErrorDetails(theme, blueProvider.lastError!),
        if (_shouldShowPairingButton(blueProvider.pairingState))
          _buildPairingButton(theme, blueProvider),
        if (_shouldShowRetryButton(blueProvider.pairingState))
          _buildRetryButton(theme, blueProvider),
      ],
    );
  }

  bool _shouldShowPairingButton(PairingState state) {
    return state == PairingState.unpaired;
  }

  bool _shouldShowRetryButton(PairingState state) {
    return state == PairingState.error;
  }

  bool _shouldShowErrorDetails(BlueProvider blueProvider) {
    return blueProvider.pairingState == PairingState.error && 
           blueProvider.lastError != null;
  }

  Widget _buildPairingButton(ThemeData theme, BlueProvider blueProvider) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () => _handlePairingButtonPress(blueProvider),
        icon: const Icon(Icons.link, size: 18),
        label: const Text('Emparejar Medidor'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
        ),
      ),
    );
  }

  Future<void> _handlePairingButtonPress(BlueProvider blueProvider) async {
    try {
      final meterProvider = Provider.of<MeterProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.token == null) {
        _showErrorSnackBar('Error: Usuario no autenticado. Inicia sesión nuevamente.');
        return;
      }

      // Check Bluetooth connection
      if (!blueProvider.isConnected) {
        _showErrorSnackBar('Error: No hay conexión Bluetooth con el medidor. Conecta el medidor primero.');
        return;
      }

      // Request new pairing token from API
      final result = await meterProvider.pairMeter(
        widget.idWorkspace,
        widget.idMeter,
      );

      if (result.isSuccess && result.value != null) {
        final newToken = result.value!.token;
        
        // Send token to physical meter via Bluetooth
        final success = await blueProvider.setApiKey(newToken);
        
        if (success) {
          // Notify parent widget about token update
          widget.onTokenUpdated?.call(newToken);
          _showSuccessSnackBar('Medidor emparejado exitosamente');
        } else {
          final error = blueProvider.lastError;
          final errorMessage = error?.message ?? 'Error al enviar token al medidor';
          _showErrorSnackBar(errorMessage);
        }
      } else {
        final errorMessage = result.message ?? 'Error al obtener token de emparejamiento';
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      _showErrorSnackBar('Error inesperado: ${e.toString()}');
    }
  }

  Widget _buildRetryButton(ThemeData theme, BlueProvider blueProvider) {
    final error = blueProvider.lastError;
    final isRetryable = error?.isRetryable ?? true;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        if (isRetryable) ...[
          OutlinedButton.icon(
            onPressed: () => _handleValidateToken(blueProvider),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Validar Token'),
          ),
          ElevatedButton.icon(
            onPressed: () => _handlePairingButtonPress(blueProvider),
            icon: const Icon(Icons.link, size: 18),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: () => _showErrorHelp(error),
            icon: const Icon(Icons.help_outline, size: 18),
            label: const Text('Ayuda'),
          ),
        ],
      ],
    );
  }

  Future<void> _handleValidateToken(BlueProvider blueProvider) async {
    try {
      await blueProvider.validateToken();
    } catch (e) {
      _showErrorSnackBar('Error al validar token: ${e.toString()}');
    }
  }

  Widget _buildErrorDetails(ThemeData theme, PairingError error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Text(
                'Detalles del Error',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Text(
            error.message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red.withValues(alpha: 0.8),
            ),
          ),
          if (error.technicalDetails != null) ...[
            const SizedBox(height: 4),
            Text(
              'Detalles técnicos: ${error.technicalDetails}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showErrorHelp(PairingError? error) {
    if (error == null) return;

    String helpMessage = _getHelpMessage(error.type);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda para Resolver el Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error: ${error.message}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Solución sugerida:'),
            const SizedBox(height: 8),
            Text(helpMessage),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  String _getHelpMessage(PairingErrorType errorType) {
    switch (errorType) {
      case PairingErrorType.bluetoothDisabled:
        return 'Ve a Configuración > Bluetooth y activa Bluetooth en tu dispositivo.';
      case PairingErrorType.bluetoothUnavailable:
        return 'Tu dispositivo no soporta Bluetooth. Usa un dispositivo compatible.';
      case PairingErrorType.permissionDenied:
        return 'Ve a Configuración > Aplicaciones > AquaMinds > Permisos y otorga permisos de ubicación.';
      case PairingErrorType.deviceNotFound:
        return 'Asegúrate de que el medidor esté encendido, cerca del dispositivo y en modo de emparejamiento.';
      case PairingErrorType.unauthorized:
        return 'Tu sesión ha expirado. Cierra la aplicación e inicia sesión nuevamente.';
      case PairingErrorType.notFound:
        return 'Verifica que el medidor esté registrado correctamente en tu workspace.';
      case PairingErrorType.networkUnavailable:
        return 'Verifica tu conexión a internet (WiFi o datos móviles) e intenta nuevamente.';
      case PairingErrorType.serverError:
        return 'El servidor está experimentando problemas. Intenta nuevamente en unos minutos.';
      default:
        return 'Intenta reiniciar la aplicación. Si el problema persiste, contacta soporte técnico.';
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme, PairingState state) {
    switch (state) {
      case PairingState.checking:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        );
      case PairingState.paired:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        );
      case PairingState.unpaired:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning,
            color: Colors.white,
            size: 16,
          ),
        );
      case PairingState.pairing:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
          ),
        );
      case PairingState.error:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error,
            color: Colors.white,
            size: 16,
          ),
        );
    }
  }

  Widget _buildStatusMessage(ThemeData theme, PairingState state, PairingError? error) {
    String message;
    String subtitle;
    Color textColor;

    switch (state) {
      case PairingState.checking:
        message = 'Validando token del medidor...';
        subtitle = 'Verificando la conexión con el servidor';
        textColor = theme.colorScheme.onSurface;
        break;
      case PairingState.paired:
        message = 'Medidor emparejado correctamente';
        subtitle = 'El medidor está sincronizado con la aplicación';
        textColor = Colors.green;
        break;
      case PairingState.unpaired:
        message = 'Medidor no emparejado';
        subtitle = error?.message ?? 'Haz clic en "Emparejar Medidor" para sincronizar';
        textColor = Colors.orange;
        break;
      case PairingState.pairing:
        message = 'Emparejando medidor...';
        subtitle = 'Enviando token de seguridad al dispositivo';
        textColor = theme.colorScheme.secondary;
        break;
      case PairingState.error:
        message = 'Error en el emparejamiento';
        subtitle = error?.message ?? 'Verifica la conexión e intenta nuevamente';
        textColor = Colors.red;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}