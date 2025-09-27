import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:intl/intl.dart';

class AnalysisTable extends StatelessWidget {
  final String idSelected;
  final ScreenSize screenSize;
  final void Function(String?)? onSelectChanged;
  final List<BaseAnalysis> analysis;

  const AnalysisTable({
    super.key,
    required this.analysis,
    required this.idSelected,
    required this.screenSize,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _buildTable(),
      );
    }
    return _buildTable();
  }

  DataTable _buildTable() {
    return DataTable(
      clipBehavior: Clip.antiAlias,
      showCheckboxColumn: false,
      columns: [
        DataColumn(label: Text("Fecha inicio")),
        DataColumn(label: Text("Fecha final")),
      ],
      rows: analysis.map(
        (average) {
          String startDate = DateFormat('dd MMM yyy')
              .format(average.parameters!.startDate ?? DateTime.now());
          String endDate = DateFormat('dd MMM yyy')
              .format(average.parameters!.endDate ?? DateTime.now());

          return DataRow(
            cells: [
              DataCell(
                Text(startDate),
              ),
              DataCell(
                Text(endDate),
              ),
            ],
            selected: average.id == idSelected,
            onSelectChanged: (value) => onSelectChanged!(average.id),
          );
        },
      ).toList(),
    );
  }
}
