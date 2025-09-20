import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Promedio por periodo",
      builder: (context, screenSize) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              if (!expandedDetailt)
                Expanded(
                  child: BaseContainer(),
                ),
              if (showDetail)
                Expanded(
                  child: BaseContainer(),
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
