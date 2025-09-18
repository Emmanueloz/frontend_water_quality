import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_detail.dart';
import 'package:provider/provider.dart';

class AveragePage extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;

  const AveragePage({
    super.key,
    required this.idWorkspace,
    required this.idMeter,
  });

  @override
  State<AveragePage> createState() => _AveragePageState();
}

class _AveragePageState extends State<AveragePage> {
  bool showDetail = false;
  String? idAverage;
  Future<List<Average>>? _getAverage;
  Average? _current;

  @override
  void initState() {
    super.initState();
    String token =
        Provider.of<AuthProvider>(context, listen: false).token ?? "";
    _getAverage = Provider.of<AnalysisProvider>(context, listen: false)
        .getAverage(widget.idWorkspace, widget.idMeter, token);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Promedios",
      builder: (context, screenSize) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: BaseContainer(
                  width: double.infinity,
                  height: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 1024,
                      child: FutureBuilder(
                        future: _getAverage,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Ocurio un error");
                            }
                            return DataTable(
                              columns: [
                                DataColumn(label: Text("Fecha inicio")),
                                DataColumn(label: Text("Fecha final")),
                                DataColumn(label: Text("Creado")),
                                DataColumn(label: Text("Ultima actualizacion")),
                                DataColumn(label: Text("Estado")),
                              ],
                              rows: snapshot.data!
                                  .map(
                                    (average) => _rowTable(average),
                                  )
                                  .toList(),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (showDetail)
                Expanded(
                  child: AverageDetail(
                    average: _current,
                    child: Center(
                      child: Text("Graficas"),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  DataRow _rowTable(Average average) {
    return DataRow(
      cells: [
        DataCell(
          Text(average.parameters!.startDate.toString()),
        ),
        DataCell(
          Text(average.parameters!.endDate.toString()),
        ),
        DataCell(
          Text(average.createdAt.toString()),
        ),
        DataCell(
          Text(average.updatedAt.toString()),
        ),
        DataCell(
          Text(
            average.status ?? "",
          ),
        ),
      ],
      selected: idAverage == average.id,
      onSelectChanged: (value) {
        setState(() {
          if (idAverage != average.id || !showDetail) {
            showDetail = true;
            idAverage = average.id;
            _current = average;
          } else {
            showDetail = false;
            idAverage = "";
            _current = null;
          }
        });
      },
    );
  }
}
