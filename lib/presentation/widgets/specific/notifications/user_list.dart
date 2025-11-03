import 'package:flutter/material.dart';

class UsersList extends StatelessWidget {
  final List<String> userIds;
  final bool isMobile;

  const UsersList({
    super.key,
    required this.userIds,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.group_outlined,
              size: 20,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 8),
            Text(
              'Usuarios notificados (${userIds.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            // color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userIds.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final userId = userIds[index];
              return ListTile(
                dense: isMobile,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 4 : 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: isMobile ? 16 : 20,
                  child: Icon(
                    Icons.person,
                    size: isMobile ? 16 : 20,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                title: Text(
                  userId,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
