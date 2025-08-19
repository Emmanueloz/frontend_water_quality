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
      chip: _buildChip(context),
      onTap: () => _showAlertDetails(context),
    );
  }

  void _showAlertDetails(BuildContext context) {
    // Validar que el alertId no esté vacío
    if (alert.id.isEmpty) {
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
        'idAlert': alert.id,
      },
      extra: alert,
    );
  }

  String _buildSubtitle() {
    return _formatDate(alert.createdAt);
  }

  Chip _buildChip(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      label: Text(
        alert.type.nameSpanish.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: alert.isActive ? colorScheme.secondary : Colors.grey[600],
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Ahora';
    }
  }
} 