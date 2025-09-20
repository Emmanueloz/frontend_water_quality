import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:intl/intl.dart';

class AnalysisDetail extends StatelessWidget {
  final bool isExpanded;
  final void Function() onExpanded;
  final void Function() onOpenChat;
  final Widget child;
  const AnalysisDetail({
    super.key,
    required this.analysis,
    required this.child,
    required this.isExpanded,
    required this.onExpanded,
    required this.onOpenChat,
  });

  final BaseAnalysis? analysis;

  @override
  Widget build(BuildContext context) {
    String typeSensor = "5";
    String? sensor = analysis!.parameters!.sensor;

    String startDate = DateFormat('dd MMM yyy')
        .format(analysis!.parameters!.startDate ?? DateTime.now());

    String endDate = DateFormat('dd MMM yyy')
        .format(analysis!.parameters!.endDate ?? DateTime.now());

    if (sensor != null) {
      typeSensor = "Sensor: $sensor";
    }

    return BaseContainer(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onExpanded,
                icon: Icon(isExpanded ? Icons.close : Icons.fullscreen),
              ),
              Text(
                "Resultados",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              if (isExpanded)
                IconButton(
                    onPressed: onOpenChat, icon: Icon(Icons.auto_awesome))
            ],
          ),
          Table(
            children: [
              TableRow(
                children: [
                  _cardInfo(context, "Estado", analysis!.status ?? ""),
                  _cardInfo(context, "Parametros", "$startDate $endDate"),
                  _cardInfo(context, "Sensores", typeSensor),
                  _cardInfo(context, "Tipo", analysis!.type ?? ""),
                ],
              )
            ],
          ),
          child,
        ],
      ),
    );
  }

  SizedBox _cardInfo(BuildContext context, String label, String value) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }
}
