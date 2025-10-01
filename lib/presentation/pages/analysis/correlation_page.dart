import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/molecules/correlation_heatmap.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:provider/provider.dart';

class CorrelationPage extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  const CorrelationPage(
      {super.key, required this.idWorkspace, required this.idMeter});

  @override
  State<CorrelationPage> createState() => _CorrelationPageState();
}

class _CorrelationPageState extends State<CorrelationPage> {
  bool expandedDetailt = false;
  bool showChat = false;
  String? idAverage;
  Future<Result<List<Correlation>>>? _getCorrelations;
  Correlation? _current;

  @override
  void initState() {
    super.initState();

    _getCorrelations = Provider.of<AnalysisProvider>(context, listen: false)
        .getCorrelations(widget.idWorkspace, widget.idMeter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Layout(
      title: "Correlación",
      builder: (context, screenSize) => AnalysisLayout<Correlation>(
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
          future: _getCorrelations,
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
        chartWidget: CorrelationHeatmap(
          labels: _current?.data?.sensors ?? [],
          matrix: _current?.data?.matrix ?? [],
          textColor: theme.colorScheme.onPrimary,
          gridColor: theme.colorScheme.tertiary,
          primaryColor: theme.colorScheme.tertiary,
          size: 400,
        ),
      ),
    );
  }
}
