import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/alert_type.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final String workspaceId;
  final String workspaceTitle;

  const AlertCard({
    super.key,
    required this.alert,
    required this.workspaceId,
    required this.workspaceTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: alert.title,
      subtitle: _buildSubtitle(),
      chip: Chip(label: Text(alert.type.nameSpanish.toUpperCase())),
      onTap: () => _showAlertDetails(context),
    );
  }

  void _showAlertDetails(BuildContext context) {
    // Validar que el alertId no esté vacío
    if (alert.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID de alerta no válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.goNamed(
      Routes.updateAlerts.name,
      pathParameters: {
        'id': workspaceId,
        'idAlert': alert.id!,
      },
      extra: alert,
    );
  }

  String _buildSubtitle() {
    return '';
  }
}
