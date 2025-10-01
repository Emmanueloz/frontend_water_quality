import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_all_period_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_period_chart.dart';
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
  bool expandedDetailt = false;
  bool showChat = false;

  String? idAverage;
  Future<Result<List<AveragePeriod>>>? _getAveragePeriod;
  AveragePeriod? _current;

  @override
  void initState() {
    super.initState();

    _getAveragePeriod = Provider.of<AnalysisProvider>(context, listen: false)
        .getAveragePeriod(widget.idWorkspace, widget.idMeter);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Promedio por periodo",
      builder: (context, screenSize) {
        return AnalysisLayout<AveragePeriod>(
          screenSize: screenSize,
          selectedItem: _current,
          expandedDetail: expandedDetailt,
          showChat: showChat,
          chatAverageId: _current?.id,
          onToggleExpand: () => setState(() {
            expandedDetailt = !expandedDetailt;
          }),
          onToggleChat: () => setState(() {
            showChat = !showChat;
          }),
          tableWidget: (screenSize) => FutureBuilder(
            future: _getAveragePeriod,
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
                  ? AveragePeriodChart(
                      width: 650,
                      name: _current!.parameters?.sensor ?? "",
                      data: _current!.data as DataAvgSensor,
                      periodType: _current!.parameters?.periodType ?? "days",
                      maxY: LimitChartSensor.getMaxY(
                        _current!.parameters?.sensor ?? "",
                      ),
                    )
                  : AverageAllPeriodChart(
                      screenSize: screenSize,
                      data: _current!.data as DataAvgAll,
                      periodType: _current!.parameters?.periodType ?? "days",
                    ),
        );
      },
    );
  }
}
