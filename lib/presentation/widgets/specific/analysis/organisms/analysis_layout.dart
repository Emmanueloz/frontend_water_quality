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

  /// Checks if chat functionality is available for the current analysis
  bool get isChatAvailable {
    if (selectedItem == null) return false;
    if (selectedItem!.id == null || selectedItem!.id!.isEmpty) return false;
    if (selectedItem!.status == null) return false;
    
    // Chat is only available for analyses with "saved" status
    return selectedItem!.status!.toLowerCase() == 'saved';
  }

  /// Gets the analysis ID to use for chat session
  String? get analysisIdForChat {
    if (!isChatAvailable) return null;
    return selectedItem!.id;
  }

  /// Gets a user-friendly message explaining why chat is not available
  String get chatUnavailableMessage {
    if (selectedItem == null) {
      return 'Selecciona un análisis para usar el chat';
    }
    if (selectedItem!.id == null || selectedItem!.id!.isEmpty) {
      return 'El análisis no tiene un ID válido';
    }
    if (selectedItem!.status == null) {
      return 'El estado del análisis no está disponible';
    }
    
    final status = selectedItem!.status!.toLowerCase();
    switch (status) {
      case 'pending':
        return 'El análisis está pendiente de procesamiento';
      case 'processing':
        return 'El análisis se está procesando';
      case 'error':
        return 'El análisis tiene errores y no está disponible para chat';
      case 'saved':
        return 'Chat disponible';
      default:
        return 'El análisis debe estar completado antes de usar el chat';
    }
  }

  /// Determines if the chat should be automatically closed when analysis changes
  bool shouldCloseChatOnAnalysisChange(T? previousAnalysis) {
    // Close chat if switching to a different analysis
    if (previousAnalysis?.id != selectedItem?.id) {
      return true;
    }
    
    // Close chat if analysis becomes unavailable for chat
    if (previousAnalysis != null && 
        previousAnalysis.status?.toLowerCase() == 'saved' && 
        !isChatAvailable) {
      return true;
    }
    
    return false;
  }

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
          height: MediaQuery.of(context).size.height * 0.8,
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
              if (isChatAvailable)
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
                            isChatAvailable: isChatAvailable,
                            chatUnavailableMessage: chatUnavailableMessage,
                            child: chartWidget!,
                          ),
                    // Página del chat
                    if (isChatAvailable)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ChatAiPage(
                          analysisId: analysisIdForChat,
                          screenSize: screenSize,
                          isInBottomSheet: true,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildChatUnavailableMessage(),
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

  Widget _buildChatUnavailableMessage() {
    final status = selectedItem?.status?.toLowerCase();
    IconData iconData;
    Color? iconColor;
    
    switch (status) {
      case 'pending':
      case 'processing':
        iconData = Icons.hourglass_empty;
        iconColor = Colors.orange[400];
        break;
      case 'error':
        iconData = Icons.error_outline;
        iconColor = Colors.red[400];
        break;
      default:
        iconData = Icons.chat_bubble_outline;
        iconColor = Colors.grey[400];
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 64,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Chat no disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              chatUnavailableMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (status == 'processing' || status == 'pending') ...[
              const SizedBox(height: 16),
              Text(
                'El chat estará disponible cuando el análisis esté completado.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
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
                  isChatAvailable: isChatAvailable,
                  chatUnavailableMessage: chatUnavailableMessage,
                  child: chartWidget!,
                ),
        ),
        if (showChat) ...[
          const VerticalDivider(),
          Expanded(
            child: isChatAvailable
                ? ChatAiPage(
                    analysisId: analysisIdForChat,
                    screenSize: screenSize,
                    isInBottomSheet: false,
                  )
                : _buildChatUnavailableMessage(),
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
