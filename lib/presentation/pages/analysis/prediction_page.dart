import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
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
  Future<List<PredictionSensor>>? _getPrediction;
  PredictionSensor? _current;

  @override
  void initState() {
    super.initState();
    String token =
        Provider.of<AuthProvider>(context, listen: false).token ?? "";
    _getPrediction = Provider.of<AnalysisProvider>(context, listen: false)
        .getPredictions(widget.idWorkspace, widget.idMeter, token);
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
        onToggleExpand: () => setState(() {
          expandedDetailt = !expandedDetailt;
        }),
        onToggleChat: () => setState(() {
          showChat = !showChat;
        }),
        tableWidget: (screenSize) => FutureBuilder<List<PredictionSensor>>(
          future: _getPrediction,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Ocurrió un error");
              }
              print(snapshot.data);
              return AnalysisTable(
                analysis: snapshot.data ?? [],
                idSelected: idAverage ?? "",
                screenSize: screenSize,
                onSelectChanged: (id) {
                  setState(() {
                    if (idAverage != id) {
                      idAverage = id;
                      _current = snapshot.data?.firstWhere(
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
        chartWidget: Container(),
      ),
    );
  }
}
