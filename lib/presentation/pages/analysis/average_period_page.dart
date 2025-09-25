import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_detail.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_all_period_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_period_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:provider/provider.dart';

class AveragePeriodPage extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  const AveragePeriodPage({
    super.key,
    required this.idWorkspace,
    required this.idMeter,
  });

  @override
  State<AveragePeriodPage> createState() => _AveragePeriodPageState();
}

class _AveragePeriodPageState extends State<AveragePeriodPage> {
  bool showDetail = false;
  bool expandedDetailt = false;
  bool showChat = false;

  String? idAverage;
  Future<List<AveragePeriod>>? _getAveragePeriod;
  AveragePeriod? _current;

  @override
  void initState() {
    super.initState();
    String token =
        Provider.of<AuthProvider>(context, listen: false).token ?? "";
    _getAveragePeriod = Provider.of<AnalysisProvider>(context, listen: false)
        .getAveragePeriod(widget.idWorkspace, widget.idMeter, token);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Promedio por periodo",
      builder: (context, screenSize) {
        return Padding(
          padding: EdgeInsets.all(10),
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
                          future: _getAveragePeriod,
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
                        ? AveragePeriodChart(
                            width: 750,
                            name: _current!.parameters?.sensor ?? "",
                            data: _current?.data as DataAvgSensor,
                            periodType:
                                _current!.parameters?.periodType ?? "days",
                            maxY: LimitChartSensor.getMaxY(
                              _current!.parameters?.sensor ?? "",
                            ),
                          )
                        : AverageAllPeriodChart(
                            screenSize: screenSize,
                            data: _current?.data as DataAvgAll,
                            periodType:
                                _current!.parameters?.periodType ?? "days",
                          ),
                  ),
                ),
              if (expandedDetailt && showChat)
                Expanded(
                  child: ChatAiPage(
                    averageId: "",
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
