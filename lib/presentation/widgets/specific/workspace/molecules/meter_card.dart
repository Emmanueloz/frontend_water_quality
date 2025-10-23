import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';

class MeterCard extends StatelessWidget {
  final String id;
  final String name;
  final String state;
  final Location location;
  final void Function()? onTap;

  const MeterCard({
    super.key,
    required this.id,
    required this.name,
    required this.state,
    required this.location,
    this.onTap,
  });

  IconData? get _statusIcon {
    switch (state) {
      case 'disconnected':
        return Icons.wifi_off_rounded;
      case 'connected':
        return Icons.wifi_rounded;
      case 'sending_data':
        return Icons.cloud_upload_rounded;
      case 'error':
        return Icons.error_rounded;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // esquinas redondeadas
      ),
      clipBehavior: Clip.antiAlias, // para que el borde se recorte bien
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.48),
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.tertiary,
                width: 10,
              ),
            ),
          ),
          // padding: const EdgeInsets.all(8),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            child: Stack(
              children: [
                // Contenido principal (columna con título y ubicación)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Ubicación:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary.withAlpha(185),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (location.nameLocation != null)
                      Text(
                        location.nameLocation!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.25,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    // espacio flexible
                    const SizedBox(height: 6),
                  ],
                ),

                // Status pill (esquina superior derecha)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    // margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Text(
                          state,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                            _statusIcon,
                            size: 18,
                            color: theme.colorScheme.tertiary,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
