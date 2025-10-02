import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/molecules/correlation_heatmap.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/form_correlation_dialog.dart';
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
  late final AnalysisProvider _analysisProvider;

  @override
  void initState() {
    super.initState();
    _analysisProvider = Provider.of<AnalysisProvider>(context, listen: false);
    _handlerGetCorrelations();
  }

  void _handlerGetCorrelations() {
    _getCorrelations =
        _analysisProvider.getCorrelations(widget.idWorkspace, widget.idMeter);
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
        formWidget: FormCorrelationDialog(
          onSubmit: (parameters) async {
            final result = await _analysisProvider.createCorrelation(
                widget.idWorkspace, widget.idMeter, parameters);

            if (!context.mounted) {
              return;
            }

            if (result.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Análisis creado con éxito'),
                ),
              );
              setState(() {
                _handlerGetCorrelations();
                idAverage = null;
                _current = null;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${result.message}'),
                ),
              );
            }
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
            _handlerGetCorrelations();
            idAverage = null;
            _current = null;
          });
        },
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
        chartWidget: _buildChart(theme),
      ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    if (_current == null) {
      return const Center(
        child: Text("Selecciona un análisis para ver el gráfico"),
      );
    }

    if (_current?.data == null) {
      return const Center(
        child: Text("No hay datos para mostrar, recarga el análisis"),
      );
    }

    return CorrelationHeatmap(
      labels: _current?.data?.sensors ?? [],
      matrix: _current?.data?.matrix ?? [],
      textColor: theme.colorScheme.onPrimary,
      gridColor: theme.colorScheme.tertiary,
      primaryColor: theme.colorScheme.tertiary,
      size: 400,
    );
  }
}
