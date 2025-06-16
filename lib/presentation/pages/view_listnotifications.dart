import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class ViewListNotifications extends StatelessWidget {
  final ScreenSize screenSize;

  const ViewListNotifications({
    super.key,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "id": "1",
        "read": "true",
        "title": "Notificación 1",
        "body": "Alerta de acceso de contaminación en el agua",
        "user_id": "2",
        "date": "2023-10-01 23:59:59"
      },
      {
        "id": "2",
        "read": "false",
        "title": "Notificación 2",
        "body": "Se detectó un nivel elevado de metales pesados en el suministro de agua.",
        "user_id": "2",
        "date": "2023-10-02 22:59:59"
      },
    ];

    return Layout(
      title: "Notificaciones",
      builder: (context, _) {
        final Size size = MediaQuery.of(context).size;

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: size.width < 600 ? size.width * 0.9 : 500,
                height: size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final rawDate = notification['date'] ?? '';
                      final parsedDate = DateTime.tryParse(rawDate);
                      final formattedDate = parsedDate != null
                          ? DateFormat("d 'de' MMMM 'de' y").format(parsedDate)
                          : '';

                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              notification['body'] ?? '',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
