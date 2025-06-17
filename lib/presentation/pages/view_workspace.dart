import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/meter_state.dart';
import 'package:frontend_water_quality/core/interface/meter_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_workspace.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_workspace.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  final ListWorkspaces type;
  const ViewWorkspace({super.key, required this.id, required this.type});

  @override
  Widget build(BuildContext context) {
    return LayoutWorkspace(
      id: id,
      title: "Espacio de trabajo $id",
      selectedIndex: 0,
      type: type,
      builder: (context, screenSize) {
        return MainWorkspace(
          id: id,
          type: type,
          screenSize: screenSize,
          meters: [
            MeterItem(
              id: "1",
              name: "Medidor 1",
              state: MeterState.error,
            ),
            MeterItem(
              id: "2",
              name: "Medidor 2",
              state: MeterState.disconnected,
            ),
            MeterItem(
              id: "3",
              name: "Medidor 3",
              state: MeterState.sendingData,
            ),
            MeterItem(
              id: "4",
              name: "Medidor 4",
              state: MeterState.connected,
            ),
          ],
        );
      },
    );
  }
}
