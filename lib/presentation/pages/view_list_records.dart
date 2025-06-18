import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_listrecords.dart';

class ViewListRecords extends StatelessWidget {
  final String id;
  final String idMeter;
  final ListWorkspaces type;
  const ViewListRecords({
    super.key,
    required this.id,
    required this.idMeter,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutMeters(
      title: "Historial del medidor $idMeter",
      id: id,
      idMeter: idMeter,
      type: type,
      selectedIndex: 1,
      builder: (context, screenSize) {
        return MainListrecords(
          id: id,
          idMeter: idMeter,
          screenSize: screenSize,
        );
      },
    );
  }
}
