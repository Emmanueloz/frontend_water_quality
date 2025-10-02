import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/form_prediction_dialog.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_prediction.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/prediction_all_chart.dart';
import 'package:provider/provider.dart';

class PredictionPage extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  const PredictionPage({
    super.key,
    required this.idWorkspace,
    required this.idMeter,
  });

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  bool expandedDetailt = false;
  bool showChat = false;
  String? idAverage;
  Future<Result<List<PredictionSensor>>>? _getPrediction;
  PredictionSensor? _current;

  @override
  void initState() {
    super.initState();

    _handlerGetPrediction();
  }

  void _handlerGetPrediction() {
    _getPrediction = Provider.of<AnalysisProvider>(context, listen: false)
        .getPredictions(widget.idWorkspace, widget.idMeter);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Predicciones",
      builder: (context, screenSize) => AnalysisLayout<PredictionSensor>(
        screenSize: screenSize,
        selectedItem: _current,
        expandedDetail: expandedDetailt,
        showChat: showChat,
        chatAverageId: _current?.id,
        formWidget: FormPredictionDialog(
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
            _handlerGetPrediction();
            idAverage = null;
            _current = null;
          });
        },
        tableWidget: (screenSize) => FutureBuilder(
          future: _getPrediction,
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
        chartWidget: _buildChartWidget(screenSize),
      ),
    );
  }

  Widget? _buildChartWidget(ScreenSize screenSize) {
    if (_current == null) {
      return null;
    }

    if (_current?.parameters?.sensor != null) {
      final DataPredSensor data = _current?.data as DataPredSensor;
      return LineChartPrediction(
        width: 650,
        sensor: _current?.parameters?.sensor ?? "",
        periodType: _current?.parameters?.periodType ?? "",
        titles: [...?data.data!.labels, ...?data.pred!.labels],
        dataValues: data.data!.values ?? [],
        predValues: data.pred!.values ?? [],
        screenSize: screenSize,
      );
    }

    final DataPredAll data = _current?.data as DataPredAll;

    return PredictionAllChart(
      data: data,
      periodType: _current?.parameters?.periodType ?? "",
      screenSize: screenSize,
    );
  }
}
