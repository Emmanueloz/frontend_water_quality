import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class NotificationDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;
  final String qualityLevel;
  final String id;

  const NotificationDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.qualityLevel,
    required this.id, 
  });

  IconData _getQualityIcon(String level) {
    switch (level.toLowerCase()) {
      case 'buena':
        return Icons.check_circle;
      case 'moderada':
        return Icons.warning_amber_rounded;
      case 'mala':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Notificación $id",
      builder: (context, screenSize) {
        return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getQualityIcon(qualityLevel)),
                      const SizedBox(width: 8),
                      Text(
                        qualityLevel.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                // Título
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                
                const SizedBox(height: 12),
                // Fecha
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 32, thickness: 1),
                
                const Text(
                  'Descripción:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}

