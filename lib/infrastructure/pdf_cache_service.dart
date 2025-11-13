import 'dart:typed_data';

/// Singleton service for in-memory PDF caching
/// 
/// This service manages a single PDF cache to reduce server load and improve
/// performance when reopening the same PDF document. It stores PDF data in
/// memory and provides methods to check, retrieve, and store cached PDFs.
class PdfCacheService {
  // Singleton instance
  static final PdfCacheService _instance = PdfCacheService._internal();
  
  /// Factory constructor returns the singleton instance
  factory PdfCacheService() => _instance;
  
  /// Private constructor for singleton pattern
  PdfCacheService._internal();
  
  // Cache storage
  Uint8List? _cachedData;
  String? _cachedUrl;
  
  /// Check if a PDF with the given URL is cached
  /// 
  /// Returns true if the URL matches the cached URL and data exists
  bool isCached(String url) {
    return _cachedUrl == url && _cachedData != null;
  }
  
  /// Get cached PDF data for the given URL
  /// 
  /// Returns the cached Uint8List if the URL matches, null otherwise
  Uint8List? getCachedData(String url) {
    if (isCached(url)) {
      return _cachedData;
    }
    return null;
  }
  
  /// Cache PDF data for the given URL
  /// 
  /// Stores the PDF data in memory, replacing any previously cached PDF
  void cachePdf(String url, Uint8List data) {
    _cachedUrl = url;
    _cachedData = data;
  }
  
  /// Clear the cached PDF data
  /// 
  /// Removes both the URL and data from cache
  void clearCache() {
    _cachedUrl = null;
    _cachedData = null;
  }
  
  /// Get the currently cached URL
  /// 
  /// Returns the URL of the cached PDF, or null if no PDF is cached
  String? get cachedUrl => _cachedUrl;
  
  /// Check if any PDF is currently cached
  /// 
  /// Returns true if cache contains data
  bool get hasCache => _cachedData != null && _cachedUrl != null;
}
