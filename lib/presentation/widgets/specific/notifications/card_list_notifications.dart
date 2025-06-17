import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';

class CardListNotifications extends StatelessWidget {
  final List<NotificationModel> notifications;
  final ScreenSize screenSize;

  const CardListNotifications({
    super.key,
    required this.notifications,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final double containerWidth =
        (screenSize == ScreenSize.smallDesktop || screenSize == ScreenSize.largeDesktop)
            ? 800
            : double.infinity;

    final double containerHeight = (size.height * 0.7 > 700) ? 700 : size.height * 0.7;

    return Center(
      child: Card(
        elevation: theme.cardTheme.elevation ?? 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: theme.cardColor,
        child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: const EdgeInsets.all(16),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final formattedDate = DateFormat("d 'de' MMMM 'de' y")
                    .format(notification.date);

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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        ),
      ),
    );
  }
}
