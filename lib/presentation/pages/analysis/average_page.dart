import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_sensor.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/form_average_dialog.dart';
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
  bool expandedDetailt = false;
  bool showChat = false;
  String? idAverage;
  Future<Result<List<Average>>>? _getAverage;
  Average? _current;

  @override
  void initState() {
    super.initState();

    _handlerGetAverage();
  }

  void _handlerGetAverage() {
    _getAverage = Provider.of<AnalysisProvider>(context, listen: false)
        .getAverage(widget.idWorkspace, widget.idMeter);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Promedios",
      builder: (context, screenSize) {
        return AnalysisLayout<Average>(
          screenSize: screenSize,
          selectedItem: _current,
          expandedDetail: expandedDetailt,
          showChat: showChat,
          chatAverageId: _current?.id,
          formWidget: FormAverageDialog(
            onSubmit: (parameters) {
              print(parameters.toJson());
            },
          ),
          onToggleExpand: () => setState(() {
            expandedDetailt = !expandedDetailt;
          }),
          onToggleChat: () => setState(() {
            showChat = !showChat;
          }),
          onRefresh: () {
            setState(() {
              _handlerGetAverage();
              idAverage = null;
              _current = null;
            });
          },
          tableWidget: (screenSize) => FutureBuilder(
            future: _getAverage,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("Ocurrió un error");
                }
                if (!snapshot.data!.isSuccess) {
                  final message = snapshot.data?.message;
                  return Text("Error $message");
                }

                return AnalysisTable(
                  analysis: snapshot.data?.value ?? [],
                  idSelected: idAverage ?? "",
                  screenSize: screenSize,
                  onSelectChanged: (id) {
                    setState(() {
                      if (idAverage != id) {
                        idAverage = id;
                        _current = snapshot.data?.value?.firstWhere(
                          (element) => element.id == id,
                        );
                      }
                    });
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          chartWidget: _current == null
              ? null
              : _current!.parameters!.sensor != null
                  ? _ChartSensor(
                      dataAverage: _current!.data as DataAverageSensor,
                      sensor: _current!.parameters?.sensor ?? "",
                    )
                  : _AllChartSensor(
                      dataAverage: _current!.data as DataAverageAll,
                    ),
        );
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
                maxY: LimitChartSensor.getMaxY(av.sensor ?? ""),
                name: av.sensor ?? ""),
          )
          .toList(),
    );
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
      maxY: LimitChartSensor.getMaxY(sensor),
      name: sensor,
      width: 500,
    );
  }
}
