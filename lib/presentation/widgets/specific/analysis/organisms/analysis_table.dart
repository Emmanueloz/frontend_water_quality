import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:intl/intl.dart';

class AnalysisTable extends StatelessWidget {
  final String idSelected;
  final void Function(bool, String?)? onSelectChanged;
  final List<BaseAnalysis> averages;

  const AnalysisTable({
    super.key,
    required this.averages,
    required this.idSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: [
        DataColumn(label: Text("Fecha inicio")),
        DataColumn(label: Text("Fecha final")),
        DataColumn(label: Text("Creado en")),
        DataColumn(label: Text("Actualizar en")),
        DataColumn(label: Text("Estatus")),
      ],
      rows: averages.map(
        (average) {
          String startDate = DateFormat('dd MMM yyy')
              .format(average.parameters!.startDate ?? DateTime.now());
          String endDate = DateFormat('dd MMM yyy')
              .format(average.parameters!.endDate ?? DateTime.now());
          String createAt = DateFormat('dd MMM yyy HH:MM')
              .format(average.createdAt ?? DateTime.now());
          String updateAt = DateFormat('dd MMM yyy HH:MM')
              .format(average.updatedAt ?? DateTime.now());

          return DataRow(
            cells: [
              DataCell(
                Text(startDate),
              ),
              DataCell(
                Text(endDate),
              ),
              DataCell(
                Text(createAt),
              ),
              DataCell(
                Text(updateAt),
              ),
              DataCell(
                Text(
                  average.status ?? "",
                ),
              ),
            ],
            selected: average.id == idSelected,
            onSelectChanged: (value) => onSelectChanged!(value!, average.id),
          );
        },
      ).toList(),
    );
  }
}
