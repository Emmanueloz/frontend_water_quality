import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class WorkspaceCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;

  const WorkspaceCard(
      {super.key,
      required this.id,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(179, 233, 233, 233),
      elevation: 2.0,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          context.go(
            "${Routes.viewWorkspace.pathRoot ?? ""}$id",
          );
        },
      ),
    );
  }
}
