import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_workspace.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  const ViewWorkspace({super.key, required this.id});

  List<String> _getDropdownItems() {
    return [
      "Medidor 1",
      "Medidor 2",
      "Medidor 3",
    ];
  }

  Widget _buildDesktopContent(BuildContext context, ScreenSize screenSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Sidebar(
          title: "Herramientas",
          screenSize: screenSize,
          children: [
            ExpansionTile(
              leading: const Icon(Icons.analytics),
              title: const Text(
                "Medidores",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: _getDropdownItems()
                  .map(
                    (m) => SidebarItem(
                      title: m,
                      leading: const Icon(Icons.analytics_outlined),
                      leadingSelected: const Icon(Icons.analytics),
                      isSelected: false,
                      onTap: () {},
                    ),
                  )
                  .toList(),
            ),
            SidebarItem(
              title: "Invitados",
              leading: const Icon(Icons.people_outline),
              leadingSelected: const Icon(Icons.people),
              isSelected: false,
              onTap: () {},
            ),
            SidebarItem(
              title: "Alertas",
              leading: const Icon(Icons.alarm_outlined),
              leadingSelected: const Icon(Icons.alarm),
              isSelected: false,
              onTap: () {},
            ),
            SidebarItem(
              title: "Configuración",
              leading: const Icon(Icons.settings_outlined),
              leadingSelected: const Icon(Icons.settings),
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),

        // Main content area with workspace grid
        MainWorkspace(
          id: id,
          idMeter: "1",
          screenSize: screenSize,
        ),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context, ScreenSize screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        DropdownButton(
          isExpanded: true,
          value: _getDropdownItems().first,
          items: _getDropdownItems()
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (value) {},
        ),
        MainWorkspace(
          id: "1",
          idMeter: "1",
          screenSize: screenSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacio de trabajo $id",
      builder: (context, screenSize) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
                  ? _buildMobileContent(
                      context,
                      screenSize,
                    )
                  : _buildDesktopContent(
                      context,
                      screenSize,
                    ),
        );
      },
    );
  }
}
