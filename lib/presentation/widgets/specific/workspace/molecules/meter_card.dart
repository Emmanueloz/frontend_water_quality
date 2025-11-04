import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';

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
    return BaseCard(
      title: name,
      tag: "Ubicación",
      subtitle: location.nameLocation,
      icon: _statusIcon,
      onTap: onTap,
      state: state,
    );
  }
}
