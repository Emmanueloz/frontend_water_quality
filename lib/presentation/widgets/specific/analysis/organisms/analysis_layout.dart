import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_detail.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/molecules/empty_analysis.dart';

class AnalysisLayout<T extends BaseAnalysis> extends StatelessWidget {
  final T? selectedItem;
  final bool expandedDetail;
  final bool showChat;
  final Widget? chartWidget;
  final Widget? formWidget;
  final Widget Function(ScreenSize screenSize) tableWidget;
  final void Function() onToggleExpand;
  final void Function() onToggleChat;
  final void Function() onRefresh;
  final void Function() onDelete;
  final String? chatAverageId;
  final ScreenSize screenSize;

  const AnalysisLayout({
    super.key,
    required this.selectedItem,
    this.expandedDetail = false,
    this.showChat = false,
    required this.chartWidget,
    required this.tableWidget,
    required this.onToggleExpand,
    required this.onToggleChat,
    this.chatAverageId,
    required this.screenSize,
    this.formWidget,
    required this.onRefresh,
    required this.onDelete,
  });

  void _showDetailBottomSheet(BuildContext context) {
    final PageController pageController = PageController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Indicador de página
              if (chatAverageId != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Desliza para ver el chat →',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              // Content
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    selectedItem == null || chartWidget == null
                        ? const EmptyAnalysis()
                        : AnalysisDetail(
                            isExpanded: false,
                            onExpanded: onToggleExpand,
                            screenSize: screenSize,
                            onDelete: onDelete,
                            onOpenChat: () {
                              if (pageController.page == 0) {
                                pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            analysis: selectedItem,
                            child: chartWidget!,
                          ),
                    // Página del chat
                    if (chatAverageId != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ChatAiPage(averageId: chatAverageId ?? ""),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => formWidget ?? Container(),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        if (!expandedDetail) ...[
          SizedBox(
            width: 400,
            height: double.infinity,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 1024,
                margin: const EdgeInsets.all(10),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showCreateDialog(context),
                          child: const Text('Crear análisis'),
                        ),
                        IconButton(
                          onPressed: onRefresh,
                          icon: const Icon(Icons.refresh),
                        )
                      ],
                    ),
                    tableWidget(screenSize),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(),
        ],
        Expanded(
          child: selectedItem == null || chartWidget == null
              ? const EmptyAnalysis()
              : AnalysisDetail(
                  screenSize: screenSize,
                  isExpanded: expandedDetail,
                  onExpanded: onToggleExpand,
                  onOpenChat: onToggleChat,
                  onDelete: onDelete,
                  analysis: selectedItem,
                  child: chartWidget!,
                ),
        ),
        if (showChat && chatAverageId != null) ...[
          const VerticalDivider(),
          Expanded(
            child: ChatAiPage(averageId: chatAverageId ?? ""),
          ),
        ]
      ],
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _showCreateDialog(context),
              child: const Text('Crear análisis'),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: tableWidget(screenSize),
        ),
        if (selectedItem != null)
          ElevatedButton(
            onPressed: () => _showDetailBottomSheet(context),
            child: const Text('Ver detalles'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
          ? buildMobileLayout(context)
          : buildDesktopLayout(context),
    );
  }
}
