import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/router/routes.dart';

class MainListNotifications extends StatelessWidget {
  final ScreenSize screenSize;
  final List<NotificationModel> notifications;

  const MainListNotifications({
    super.key,
    required this.screenSize,
    required this.notifications,
  });

  double _getMaxWidth() {
    switch (screenSize) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 700;
      case ScreenSize.smallDesktop:
        return 900;
      default:
        return 900;
    }
  }

  EdgeInsets _getContainerMargin() {
    return screenSize == ScreenSize.mobile
        ? const EdgeInsets.all(8)
        : const EdgeInsets.all(16);
  }

  EdgeInsets _getContainerPadding() {
    return screenSize == ScreenSize.mobile
        ? const EdgeInsets.all(12)
        : const EdgeInsets.all(16);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseContainer(
      margin: _getContainerMargin(),
      padding: _getContainerPadding(),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _getMaxWidth()),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final formattedDate =
                  DateFormat("d 'de' MMMM 'de' y").format(notification.date);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  elevation: 0,
                  // shadowColor: theme.colorScheme.surface.withOpacity(0.1),
                  color: theme.colorScheme.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      context.goNamed(
                        Routes.notificationDetails.name,
                        pathParameters: {'id': notification.id},
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize == ScreenSize.mobile ? 10 : 16,
                        vertical: screenSize == ScreenSize.mobile ? 8 : 12,
                      ),
                      child: Row(
                        children: [
                          // Leading icon
                          Container(
                            width: screenSize == ScreenSize.mobile ? 25 : 48,
                            height: screenSize == ScreenSize.mobile ? 25 : 48,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: theme.colorScheme.tertiary,
                              size: screenSize == ScreenSize.mobile ? 17 : 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Title
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Date badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize == ScreenSize.mobile ? 8 : 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.tertiary,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              formattedDate,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize == ScreenSize.mobile ? 10 : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}