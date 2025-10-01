import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/analysis_detail.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/empty_analysis.dart';

class AnalysisLayout<T extends BaseAnalysis> extends StatelessWidget {
  final T? selectedItem;
  final bool expandedDetail;
  final bool showChat;
  final Widget? chartWidget;
  final Widget Function(ScreenSize screenSize) tableWidget;
  final void Function() onToggleExpand;
  final void Function() onToggleChat;
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
  });

  void _showDetailBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
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
              // Content
              Expanded(
                child: selectedItem == null || chartWidget == null
                    ? const EmptyAnalysis()
                    : AnalysisDetail(
                        screenSize: screenSize,
                        isExpanded: false,
                        onExpanded: onToggleExpand,
                        onOpenChat: onToggleChat,
                        analysis: selectedItem,
                        child: chartWidget!,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
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
                child: tableWidget(screenSize),
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

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: tableWidget(screenSize),
        ),
        if (selectedItem != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showDetailBottomSheet(context),
              child: const Text('Ver detalles'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(),
    );
  }
}
