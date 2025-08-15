import 'package:flutter/material.dart';
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
    
    print('AlertCard: Navigating to edit alert');
    print('AlertCard: Alert ID: ${alert.id}');
    print('AlertCard: Alert title: "${alert.title}"');
    print('AlertCard: Alert type: "${alert.type}"');
    
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
    Color chipColor;
    String chipText;

    switch (alert.type.toLowerCase()) {
      case 'good':
        chipColor = Colors.green;
        chipText = 'BUENO';
        break;
      case 'moderate':
        chipColor = Colors.blue;
        chipText = 'MODERADO';
        break;
      case 'poor':
        chipColor = Colors.orange;
        chipText = 'MALO';
        break;
      case 'dangerous':
        chipColor = Colors.red;
        chipText = 'PELIGROSO';
        break;
      case 'excellent':
        chipColor = Colors.green[700]!;
        chipText = 'EXCELENTE';
        break;
      default:
        chipColor = Colors.grey;
        chipText = alert.type.toUpperCase();
    }

    return Chip(
      label: Text(
        chipText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
      backgroundColor: alert.isActive ? chipColor : Colors.grey[600],
      visualDensity: VisualDensity.compact,
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
      return 'Ahora mismo';
    }
  }
} 