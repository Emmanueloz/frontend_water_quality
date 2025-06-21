import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class MainListNotifications extends StatelessWidget {
  final ScreenSize screenSize;
  final List<NotificationModel> notifications;

  const MainListNotifications({
    super.key,
    required this.screenSize,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final formattedDate =
                DateFormat("d 'de' MMMM 'de' y").format(notification.date);

            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.secondary),
                  ),
                ],
              ),
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    notification.body,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
