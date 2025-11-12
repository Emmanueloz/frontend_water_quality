import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/infrastructure/dio_helper.dart';
import 'package:frontend_water_quality/infrastructure/pdf_cache_service.dart';
import 'package:frontend_water_quality/infrastructure/pdf_download_service.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/pdf_toolbar.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/pdf_search_overlay.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/pdf_zoom_menu_overlay.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/pdf_settings_menu_overlay.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String url;
  final String token;
  final String? filename;
  final VoidCallback? onClose;

  const PdfViewer({
    super.key,
    required this.url,
    required this.token,
    this.filename,
    this.onClose,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  // Controllers
  late PdfViewerController _pdfViewerController;
  late UndoHistoryController _undoHistoryController;

  // UI State
  bool _isLoading = true;
  String? _errorMessage;

  // PDF Data
  Uint8List? _pdfData;

  // Cache Service
  final PdfCacheService _cacheService = PdfCacheService();

  // Platform detection (Sub-task 7.1)
  bool _isDesktopWeb = false;

  // Toolbar state
  bool _showAnnotationToolbar = false;
  Annotation? _selectedAnnotation;
  PdfAnnotationMode _currentAnnotationMode = PdfAnnotationMode.none;

  // Page state
  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;

  // Overlay state
  OverlayEntry? _searchOverlayEntry;
  OverlayEntry? _zoomMenuOverlayEntry;
  OverlayEntry? _settingsMenuOverlayEntry;

  // PDF settings
  PdfPageLayoutMode _pageLayoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection _scrollDirection = PdfScrollDirection.vertical;

  // Filename from response headers
  String? _downloadFilename;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _undoHistoryController = UndoHistoryController();

    // Listen to page changes
    _pdfViewerController.addListener(_onPdfViewerStateChanged);

    _loadPdf();
  }

  void _onPdfViewerStateChanged() {
    if (mounted) {
      setState(() {
        _currentPage = _pdfViewerController.pageNumber;
        _totalPages = _pdfViewerController.pageCount;
        _zoomLevel = _pdfViewerController.zoomLevel;
      });
    }
  }

  /// Show search overlay
  void _showSearchOverlay() {
    if (_searchOverlayEntry != null) {
      _searchOverlayEntry!.remove();
      _searchOverlayEntry = null;
      return;
    }

    _searchOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: MediaQuery.of(context).size.width / 2 - 200,
        child: PdfSearchOverlay(
          controller: _pdfViewerController,
          onClose: () {
            _searchOverlayEntry?.remove();
            _searchOverlayEntry = null;
          },
        ),
      ),
    );

    Overlay.of(context).insert(_searchOverlayEntry!);
  }

  /// Show zoom menu overlay
  void _showZoomMenu() {
    if (_zoomMenuOverlayEntry != null) {
      _zoomMenuOverlayEntry!.remove();
      _zoomMenuOverlayEntry = null;
      return;
    }

    _zoomMenuOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: MediaQuery.of(context).size.width / 2 - 75,
        child: PdfZoomMenuOverlay(
          currentZoomLevel: _zoomLevel,
          onZoomLevelSelected: (level) {
            _pdfViewerController.zoomLevel = level;
            // Force update zoom level in state
            setState(() {
              _zoomLevel = level;
            });
          },
          onClose: () {
            _zoomMenuOverlayEntry?.remove();
            _zoomMenuOverlayEntry = null;
          },
        ),
      ),
    );

    Overlay.of(context).insert(_zoomMenuOverlayEntry!);
  }

  /// Show settings menu overlay
  void _showSettingsMenu() {
    if (_settingsMenuOverlayEntry != null) {
      _settingsMenuOverlayEntry!.remove();
      _settingsMenuOverlayEntry = null;
      return;
    }

    _settingsMenuOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        right: 20,
        child: PdfSettingsMenuOverlay(
          initialLayoutMode: _pageLayoutMode,
          initialScrollDirection: _scrollDirection,
          onLayoutModeChanged: (mode) {
            setState(() {
              _pageLayoutMode = mode;
            });
          },
          onScrollDirectionChanged: (direction) {
            setState(() {
              _scrollDirection = direction;
            });
          },
          onClose: () {
            _settingsMenuOverlayEntry?.remove();
            _settingsMenuOverlayEntry = null;
          },
        ),
      ),
    );

    Overlay.of(context).insert(_settingsMenuOverlayEntry!);
  }

  @override
  void dispose() {
    _removeAllOverlays();
    _pdfViewerController.removeListener(_onPdfViewerStateChanged);
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _removeAllOverlays() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    _zoomMenuOverlayEntry?.remove();
    _zoomMenuOverlayEntry = null;
    _settingsMenuOverlayEntry?.remove();
    _settingsMenuOverlayEntry = null;
  }

  /// Load PDF with cache integration (Sub-task 3.2)
  /// Enhanced with detailed error handling (Sub-task 8.1)
  Future<void> _loadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check if PDF is cached
      if (_cacheService.isCached(widget.url)) {
        final cachedData = _cacheService.getCachedData(widget.url);
        if (cachedData != null) {
          debugPrint('PDF loaded from cache: ${widget.url}');
          setState(() {
            _pdfData = cachedData;
            _isLoading = false;
          });
          return;
        }
      }

      // Fetch from network with authentication headers using Dio
      debugPrint('Fetching PDF from network: ${widget.url}');
      final dio = DioHelper.createDio();
      final response = await dio.get<List<int>>(
        widget.url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${widget.token}",
          },
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final pdfBytes = Uint8List.fromList(response.data!);

        print(response.extra);
        print(response.headers);
        print(response.requestOptions.toString());

        // Extract filename from Content-Disposition header
        try {
          final headers = response.headers.map;
          debugPrint('Response headers: $headers');

          // Try different header name variations (case-insensitive)
          String? contentDisposition;
          for (var key in headers.keys) {
            if (key.toLowerCase() == 'content-disposition') {
              contentDisposition = headers[key]?.first;
              break;
            }
          }

          if (contentDisposition != null) {
            debugPrint('Content-Disposition header: $contentDisposition');
            // Match filename with or without quotes, and handle UTF-8 encoding
            final filenameRegex = RegExp(
                'filename[*]?=(?:UTF-8\'\')?(.*?)(?:;|\$)',
                caseSensitive: false);
            final match = filenameRegex.firstMatch(contentDisposition);
            if (match != null && match.groupCount >= 1) {
              var filename = match.group(1)?.trim() ?? '';
              // Remove quotes if present
              if (filename.startsWith('"') && filename.endsWith('"')) {
                filename = filename.substring(1, filename.length - 1);
              } else if (filename.startsWith("'") && filename.endsWith("'")) {
                filename = filename.substring(1, filename.length - 1);
              }
              _downloadFilename = Uri.decodeComponent(filename);
              debugPrint('Extracted filename from headers: $_downloadFilename');
            }
          } else {
            debugPrint('No Content-Disposition header found in response');
          }
        } catch (e) {
          debugPrint('Error extracting filename from headers: $e');
        }

        // Store in cache for future use
        _cacheService.cachePdf(widget.url, pdfBytes);

        debugPrint('PDF loaded successfully: ${pdfBytes.length} bytes');
        setState(() {
          _pdfData = pdfBytes;
          _isLoading = false;
        });
      } else {
        final errorMsg =
            'Error al cargar el PDF: Código ${response.statusCode}';
        debugPrint('PDF load failed: $errorMsg');
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
        _showErrorDialog(
          'Error al cargar PDF',
          'No se pudo cargar el documento. Código de error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMsg;
      String dialogMsg;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Tiempo de espera agotado';
        dialogMsg =
            'La conexión tardó demasiado. Por favor, verifica tu conexión a internet e intenta nuevamente.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'Error de conexión';
        dialogMsg =
            'No se pudo conectar al servidor. Por favor, verifica tu conexión a internet.';
      } else if (e.response?.statusCode == 401) {
        errorMsg = 'No autorizado';
        dialogMsg =
            'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
      } else if (e.response?.statusCode == 403) {
        errorMsg = 'Acceso denegado';
        dialogMsg = 'No tienes permisos para acceder a este documento.';
      } else if (e.response?.statusCode == 404) {
        errorMsg = 'Documento no encontrado';
        dialogMsg = 'El documento solicitado no existe o ha sido eliminado.';
      } else {
        errorMsg = 'Error al cargar el PDF';
        dialogMsg =
            'Ocurrió un error al cargar el documento: ${e.message ?? "Error desconocido"}';
      }

      debugPrint('PDF load error: $errorMsg - ${e.toString()}');
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
      _showErrorDialog('Error al cargar PDF', dialogMsg);
    } catch (e) {
      final errorMsg = 'Error inesperado al cargar el PDF';
      debugPrint('PDF load unexpected error: ${e.toString()}');
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
      _showErrorDialog(
        'Error inesperado',
        'Ocurrió un error inesperado al cargar el documento: ${e.toString()}',
      );
    }
  }

  /// Show error dialog with retry option (Sub-task 8.1)
  void _showErrorDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadPdf();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// Download PDF with enhanced error handling (Sub-task 8.2, 8.3)
  Future<void> _downloadPdf() async {
    if (_pdfData == null) {
      _showSnackBar('No hay PDF para descargar', isError: true);
      return;
    }

    try {
      // Show loading indicator (Sub-task 8.4)
      _showSnackBar('Descargando PDF...', isLoading: true);

      // Use filename from: 1) widget parameter, 2) response headers, 3) fallback
      String filename = widget.filename ??
          _downloadFilename ??
          'reporte_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await PdfDownloadService.downloadFromController(
        _pdfViewerController,
        filename,
      );

      // Show success message (Sub-task 8.3)
      _showSnackBar('PDF guardado en la carpeta Descargas', isError: false);
    } catch (e) {
      debugPrint('Download failed: ${e.toString()}');

      // Check exception type by name to handle platform-specific exceptions
      final exceptionType = e.runtimeType.toString();

      if (exceptionType == 'FileWriteException') {
        _showDownloadErrorDialog(
          'Error al guardar',
          e.toString(),
        );
      } else if (exceptionType == 'PdfDownloadException') {
        _showDownloadErrorDialog(
          'Error al descargar',
          e.toString(),
        );
      } else {
        _showDownloadErrorDialog(
          'Error inesperado',
          'Ocurrió un error inesperado al descargar el PDF: ${e.toString()}',
        );
      }
    }
  }

  /// Show download error dialog with retry option (Sub-task 8.2)
  void _showDownloadErrorDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadPdf();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// Show snackbar for feedback messages (Sub-task 8.3)
  void _showSnackBar(String message,
      {bool isError = false, bool isLoading = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (isLoading) const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor:
            isError ? Colors.red : (isLoading ? Colors.blue : Colors.green),
        duration: Duration(seconds: isLoading ? 10 : 3),
      ),
    );
  }

  /// Handle toolbar actions
  void _handleToolbarAction(String action, {dynamic data}) {
    switch (action) {
      case 'undo':
        _undoHistoryController.undo();
        break;
      case 'redo':
        _undoHistoryController.redo();
        break;
      case 'previousPage':
        _pdfViewerController.previousPage();
        break;
      case 'nextPage':
        _pdfViewerController.nextPage();
        break;
      case 'jumpToPage':
        if (data is int) {
          _pdfViewerController.jumpToPage(data);
        }
        break;
      case 'zoomIn':
        _pdfViewerController.zoomLevel =
            (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0);
        // Force update zoom level in state
        setState(() {
          _zoomLevel = _pdfViewerController.zoomLevel;
        });
        break;
      case 'zoomOut':
        _pdfViewerController.zoomLevel =
            (_pdfViewerController.zoomLevel - 0.25).clamp(1.0, 3.0);
        // Force update zoom level in state
        setState(() {
          _zoomLevel = _pdfViewerController.zoomLevel;
        });
        break;
      case 'zoomPercentage':
        _showZoomMenu();
        break;
      case 'download':
        _downloadPdf();
        break;
      case 'search':
        _showSearchOverlay();
        break;
      case 'settings':
        _showSettingsMenu();
        break;
      case 'toggleAnnotations':
        setState(() {
          _showAnnotationToolbar = !_showAnnotationToolbar;
        });
        break;
      case 'highlight':
        _handleAnnotationMode(PdfAnnotationMode.highlight);
        break;
      case 'underline':
        _handleAnnotationMode(PdfAnnotationMode.underline);
        break;
      case 'strikethrough':
        _handleAnnotationMode(PdfAnnotationMode.strikethrough);
        break;
      case 'squiggly':
        _handleAnnotationMode(PdfAnnotationMode.squiggly);
        break;
      case 'deleteAnnotation':
        if (_selectedAnnotation != null) {
          _pdfViewerController.removeAnnotation(_selectedAnnotation!);
          setState(() {
            _selectedAnnotation = null;
          });
        }
        break;
      case 'lockAnnotation':
        if (_selectedAnnotation != null) {
          setState(() {
            _selectedAnnotation!.isLocked = !_selectedAnnotation!.isLocked;
          });
        }
        break;
    }
  }

  void _handleAnnotationMode(PdfAnnotationMode mode) {
    setState(() {
      if (_currentAnnotationMode == mode) {
        _currentAnnotationMode = PdfAnnotationMode.none;
        _pdfViewerController.annotationMode = PdfAnnotationMode.none;
      } else {
        _currentAnnotationMode = mode;
        _pdfViewerController.annotationMode = mode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle orientation changes (Sub-task 7.4)
    // Re-detect platform on every build to handle orientation/size changes
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb;

    // Update platform flags based on current screen size
    _isDesktopWeb = isWeb && screenWidth >= 800;

    return Layout(
      title: widget.filename ?? "Reporte",
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      final theme = Theme.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPdf,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_pdfData == null) {
      final theme = Theme.of(context);
      return Center(
        child: Text(
          'No se pudo cargar el PDF',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    // Build PDF viewer with toolbar
    return Column(
      children: [
        // Toolbar
        PdfToolbar(
          controller: _pdfViewerController,
          undoController: _undoHistoryController,
          isDesktopWeb: _isDesktopWeb,
          onAction: _handleToolbarAction,
          selectedAnnotation: _selectedAnnotation,
          currentPage: _currentPage,
          totalPages: _totalPages,
          zoomLevel: _zoomLevel,
          canUndo: _undoHistoryController.value.canUndo,
          canRedo: _undoHistoryController.value.canRedo,
          showAnnotationToolbar: _showAnnotationToolbar,
          currentAnnotationMode: _currentAnnotationMode,
        ),
        // PDF Viewer
        Expanded(
          child: SfPdfViewer.memory(
            _pdfData!,
            controller: _pdfViewerController,
            undoController: _undoHistoryController,
            interactionMode: PdfInteractionMode.selection,
            scrollDirection: _scrollDirection,
            pageLayoutMode: _pageLayoutMode,
            canShowScrollHead: true,
            enableDocumentLinkAnnotation: true,
            canShowTextSelectionMenu:
                false, // Disable default menu (we'll use custom)
            onAnnotationSelected: (Annotation annotation) {
              setState(() {
                _selectedAnnotation = annotation;
              });
            },
            onAnnotationDeselected: (Annotation annotation) {
              setState(() {
                _selectedAnnotation = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
