import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';
import 'package:intl/intl.dart';

class AnalysisDetail extends StatelessWidget {
  final bool isExpanded;
  final ScreenSize screenSize;
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
    required this.screenSize,
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

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (screenSize == ScreenSize.smallDesktop ||
                    screenSize == ScreenSize.largeDesktop)
                  IconButton(
                    onPressed: onExpanded,
                    icon: Icon(
                      isExpanded ? Icons.arrow_right : Icons.arrow_left,
                      size: 30,
                    ),
                  ),
                Text(
                  "Resultados",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    onPressed: onOpenChat, icon: Icon(Icons.auto_awesome))
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _cardInfo(context, "Estado", analysis!.status ?? ""),
                  _cardInfo(context, "Parametros", "$startDate $endDate"),
                  _cardInfo(context, "Sensores", typeSensor),
                  _cardInfo(context, "Tipo", analysis!.type ?? ""),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  SizedBox _cardInfo(BuildContext context, String label, String value) {
    return SizedBox(
      width: 200,
      height: 150,
      child: BaseCard(
        title: label,
        subtitle: value,
      ),
    );
  }
}
