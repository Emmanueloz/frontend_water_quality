import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/molecules/analysis_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AnalysisPage extends StatelessWidget {
  final String idWorkspace;
  final String idMeter;
  const AnalysisPage(
      {super.key, required this.idWorkspace, required this.idMeter});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    final listAnalysis = [
      AnalysisCard(
        title: "Promedios",
        icon: Icons.analytics,
        screenSize: screenSize,
        onTab: () => context.goNamed(
          Routes.analysisAverage.name,
          pathParameters: {
            "id": idWorkspace,
            "idMeter": idMeter,
          },
        ),
      ),
      AnalysisCard(
        title: "Promedios por periodo",
        icon: Icons.bar_chart,
        screenSize: screenSize,
        onTab: () => context.goNamed(
          Routes.analysisAveragePeriod.name,
          pathParameters: {
            "id": idWorkspace,
            "idMeter": idMeter,
          },
        ),
      ),
      AnalysisCard(
        title: "Predicción",
        icon: Icons.line_axis,
        screenSize: screenSize,
        onTab: () => context.goNamed(
          Routes.analysisPrediction.name,
          pathParameters: {
            "id": idWorkspace,
            "idMeter": idMeter,
          },
        ),
      ),
      AnalysisCard(
        title: "Correlación",
        icon: Icons.bubble_chart,
        screenSize: screenSize,
        onTab: () => context.goNamed(
          Routes.analysisCorrelation.name,
          pathParameters: {
            "id": idWorkspace,
            "idMeter": idMeter,
          },
        ),
      )
    ];

    return BaseContainer(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            "Modulos de análisis",
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          GridItemBuilder(
            itemCount: 4,
            itemBuilder: (context, index) => listAnalysis[index],
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }
}
