import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_sensor.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_detail.dart';
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
                              return AnalysisTable(
                                analysis: snapshot.data ?? [],
                                idSelected: idAverage ?? "",
                                screenSize: screenSize,
                                onSelectChanged: (value, id) {
                                  setState(
                                    () {
                                      if (idAverage != id || !showDetail) {
                                        showDetail = true;
                                        idAverage = id;
                                        _current = snapshot.data?.firstWhere(
                                          (element) => element.id == id,
                                        );
                                      } else {
                                        showDetail = false;
                                        idAverage = "";
                                        _current = null;
                                      }
                                    },
                                  );
                                },
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
                  child: AnalysisDetail(
                    isExpanded: expandedDetailt,
                    onExpanded: () => setState(() {
                      expandedDetailt = !expandedDetailt;
                    }),
                    onOpenChat: () => setState(() {
                      showChat = !showChat;
                    }),
                    analysis: _current,
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
                  child: ChatAiPage(averageId: _current!.id),
                ),
            ],
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
