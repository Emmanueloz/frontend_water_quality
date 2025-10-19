import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/molecules/analysis_modal_delete.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_table.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_all_period_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/average_period_chart.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/form_period_dialog.dart';
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
  late final AnalysisProvider _analysisProvider;

  @override
  void initState() {
    super.initState();
    _analysisProvider = Provider.of<AnalysisProvider>(context, listen: false);

    _handlerGetAveragePeriod();
  }

  void _handlerGetAveragePeriod() {
    _getAveragePeriod =
        _analysisProvider.getAveragePeriod(widget.idWorkspace, widget.idMeter);
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
          onDelete: () {
            if (_current == null || _current!.id == null) {
              return;
            }

            AnalysisModalDelete.show(
              context,
              onDelete: () async {
                final result = await _analysisProvider.delete(_current!.id!);
                if (!context.mounted) {
                  return;
                }

                if (result.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Análisis eliminado con éxito'),
                    ),
                  );
                  setState(() {
                    _handlerGetAveragePeriod();
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
            );
          },
          formWidget: FormPeriodDialog(
            onSubmit: (parameters) async {
              final result = await _analysisProvider.createAveragesPeriod(
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
                  _handlerGetAveragePeriod();
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
              _handlerGetAveragePeriod();
              idAverage = null;
              _current = null;
            });
          },
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
          chartWidget: _buildChart(screenSize),
        );
      },
    );
  }

  Widget _buildChart(ScreenSize screenSize) {
    if (_current == null) {
      return const Center(
        child: Text("No hay datos para mostrar, recarga el análisis"),
      );
    }

    if (_current!.data == null) {
      return const Center(
        child: Text("No hay datos para mostrar"),
      );
    }

    if (_current!.parameters!.sensor != null) {
      return AveragePeriodChart(
        width: 650,
        screenSize: screenSize,
        name: _current!.parameters?.sensor ?? "",
        data: _current!.data as DataAvgSensor,
        periodType: _current!.parameters?.periodType ?? "days",
        maxY: LimitChartSensor.getMaxY(
          _current!.parameters?.sensor ?? "",
        ),
      );
    } else {
      return AverageAllPeriodChart(
        screenSize: screenSize,
        data: _current!.data as DataAvgAll,
        periodType: _current!.parameters?.periodType ?? "days",
      );
    }
  }
}
