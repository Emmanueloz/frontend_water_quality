import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  const ViewWorkspace({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Workspaces - $id",
      builder: (context, screenSize) {
        print("screenSize: $screenSize");

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              if (screenSize == ScreenSize.smallDesktop ||
                  screenSize == ScreenSize.largeDesktop)
                _buildSidebar(
                  context,
                  screenSize == ScreenSize.smallDesktop ? 200 : 400,
                ),

              // Main content area with workspace grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(179, 211, 211, 211),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Medidor 1",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, double width) {
    return Container(
      width: width, // Fixed width for sidebar
      height: double.infinity, // Take full height
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 211, 211, 211),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              "Medidores",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SideBarItem(
            title: "Medidor 1",
            onTap: () {},
          ),
          SideBarItem(
            title: "Medidor 2",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
