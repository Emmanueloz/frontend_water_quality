import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/meter_state.dart';

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
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: _buildChip(context),
              ),
            ],
          ),
        ),
      ),
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
