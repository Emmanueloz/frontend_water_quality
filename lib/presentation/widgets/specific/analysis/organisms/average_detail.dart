import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:intl/intl.dart';

class AverageDetail extends StatelessWidget {
  final bool isExpanded;
  final void Function() onExpanded;
  final void Function() onOpenChat;
  final Widget child;
  const AverageDetail({
    super.key,
    required this.average,
    required this.child,
    required this.isExpanded,
    required this.onExpanded,
    required this.onOpenChat,
  });

  final Average? average;

  @override
  Widget build(BuildContext context) {
    String typeSensor = "5";
    String? sensor = average!.parameters!.sensor;

    String startDate = DateFormat('dd MMM yyy')
        .format(average!.parameters!.startDate ?? DateTime.now());

    String endDate = DateFormat('dd MMM yyy')
        .format(average!.parameters!.endDate ?? DateTime.now());

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
                  _cardInfo(context, "Estado", average!.status ?? ""),
                  _cardInfo(context, "Parametros", "$startDate $endDate"),
                  _cardInfo(context, "Sensores", typeSensor),
                  _cardInfo(context, "Tipo", average!.type ?? ""),
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
