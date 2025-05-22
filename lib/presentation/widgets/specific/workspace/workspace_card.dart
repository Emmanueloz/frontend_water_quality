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
    Widget iconAvatar = Icon(Icons.lock_outlined);

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
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text("Creador: $owner"),
              Spacer(),
              Chip(
                avatar: iconAvatar,
                label: Text(type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
