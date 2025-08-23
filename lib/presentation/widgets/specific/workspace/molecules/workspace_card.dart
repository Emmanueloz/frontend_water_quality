import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';

class WorkspaceCard extends StatelessWidget {
  final String id;
  final String title;
  final String owner;
  final TypeWorkspace? type;
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
    Widget iconAvatar = Icon(
      type == TypeWorkspace.private
          ? Icons.lock_outline
          : Icons.public_outlined,
    );

    return BaseCard(
      title: title,
      subtitle: "Creador: $owner",
      chip: Chip(
        avatar: iconAvatar,
        label: Text(type!.nameSpanish),
      ),
      onTap: onTap,
    );
  }
}
