import 'package:flutter/material.dart';

class WorkspaceCard extends StatelessWidget {
  final String id;
  final String title;
  final String owner;
  final String type;
  final void Function()? onTap;

  const WorkspaceCard({
    super.key,
    required this.id,
    required this.title,
    required this.owner,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
              ),
              const SizedBox(height: 4),
              Text(
                owner,
              ),
              Text(
                type,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
