import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_workspace.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  const ViewWorkspace({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacio de trabajo $id",
      builder: (context, screenSize) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              if (screenSize == ScreenSize.smallDesktop ||
                  screenSize == ScreenSize.largeDesktop)
                Sidebar(
                  title: "Medidores",
                  screenSize: screenSize,
                  children: [
                    SideBarItem(
                      title: "Medidor 1",
                      leading: const Icon(Icons.analytics_outlined),
                      leadingSelected: const Icon(Icons.analytics),
                      isSelected: true,
                      onTap: () {},
                    ),
                    SideBarItem(
                      title: "Medidor 2",
                      leading: const Icon(Icons.analytics_outlined),
                      leadingSelected: const Icon(Icons.analytics),
                      onTap: () {},
                    ),
                  ],
                ),

              // Main content area with workspace grid
              MainWorkspace(
                idMeter: "1",
                screenSize: screenSize,
              ),
            ],
          ),
        );
      },
    );
  }
}
