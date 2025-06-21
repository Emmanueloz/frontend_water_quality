import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/meter_state.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';

class MeterCard extends StatelessWidget {
  final String id;
  final String name;
  final MeterState state;
  final void Function()? onTap;
  const MeterCard({
    super.key,
    required this.id,
    required this.name,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: name,
      chip: _buildChip(context),
      onTap: onTap,
    );
  }

  Chip _buildChip(BuildContext context) {
    String stateName;
    switch (state) {
      case MeterState.connected:
        stateName = "Conectado";
        break;
      case MeterState.sendingData:
        stateName = "Enviando datos";
        break;
      case MeterState.disconnected:
        stateName = "Desconectado";
        break;
      case MeterState.error:
        stateName = "Error";
        break;
    }

    return Chip(
      label: Text(stateName),
    );
  }
}
