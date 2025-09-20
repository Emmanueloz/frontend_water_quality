import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_sensor.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_detail.dart';
import 'package:intl/intl.dart';
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
  bool expandedDetailt = false;
  bool showChat = false;
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
              if (!expandedDetailt)
                Expanded(
                  child: BaseContainer(
                    width: double.infinity,
                    height: double.infinity,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 1024,
                        margin: EdgeInsets.all(10),
                        child: FutureBuilder(
                          future: _getAverage,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("Ocurio un error");
                              }
                              return DataTable(
                                showCheckboxColumn: false,
                                columns: [
                                  DataColumn(label: Text("Fecha inicio")),
                                  DataColumn(label: Text("Fecha final")),
                                  DataColumn(label: Text("Creado en")),
                                  DataColumn(label: Text("Actualizar en")),
                                  DataColumn(label: Text("Estatus")),
                                ],
                                headingTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                    isExpanded: expandedDetailt,
                    onExpanded: () => setState(() {
                      expandedDetailt = !expandedDetailt;
                    }),
                    onOpenChat: () => setState(() {
                      showChat = !showChat;
                    }),
                    average: _current,
                    child: _current!.parameters!.sensor != null
                        ? _ChartSensor(
                            dataAverage: _current!.data as DataAverageSensor,
                            sensor: _current!.parameters?.sensor ?? "",
                          )
                        : _AllChartSensor(
                            dataAverage: _current!.data as DataAverageAll),
                  ),
                ),
              if (expandedDetailt && showChat)
                Expanded(
                  child: ChatAiPage(average: _current),
                ),
            ],
          ),
        );
      },
    );
  }

  DataRow _rowTable(Average average) {
    String startDate = DateFormat('dd MMM yyy')
        .format(average.parameters!.startDate ?? DateTime.now());
    String endDate = DateFormat('dd MMM yyy')
        .format(average.parameters!.startDate ?? DateTime.now());
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

class _AllChartSensor extends StatelessWidget {
  final DataAverageAll dataAverage;
  const _AllChartSensor({required this.dataAverage});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: dataAverage.result!
          .map(
            (av) => AverageChart(
                width: 300,
                average: av.average ?? 0,
                min: av.min ?? 0,
                max: av.max ?? 0,
                maxY: _getMaxY(av.sensor ?? ""),
                name: av.sensor ?? ""),
          )
          .toList(),
    );
  }

  double _getMaxY(String sensor) {
    switch (sensor) {
      case "temperature":
        return 60;
      case "ph":
        return 14.0;
      case "tds":
        return 700.0;
      case "conductivity":
        return 3000.0;
      case "turbidity":
        return 50;
      default:
        return 0;
    }
  }
}

class _ChartSensor extends StatelessWidget {
  final DataAverageSensor dataAverage;
  final String sensor;
  const _ChartSensor({required this.dataAverage, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return AverageChart(
      average: dataAverage.stats?.average ?? 0,
      min: dataAverage.stats?.min ?? 0,
      max: dataAverage.stats?.max ?? 0,
      maxY: _getMaxY(sensor),
      name: sensor,
      width: 500,
    );
  }

  double _getMaxY(String sensor) {
    switch (sensor) {
      case "temperature":
        return 60;
      case "ph":
        return 14.0;
      case "tds":
        return 700.0;
      case "conductivity":
        return 3000.0;
      case "turbidity":
        return 70;
      default:
        return 0;
    }
  }
}
