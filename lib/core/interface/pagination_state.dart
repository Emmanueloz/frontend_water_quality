class PaginationState {
  final List<String> indexHistory;
  final int limit;
  final bool hasMore;

  const PaginationState({
    this.indexHistory = const [],
    this.limit = 10,
    this.hasMore = false,
  });

  // Navegar a la siguiente página
  PaginationState nextPage(String lastId) {
    return PaginationState(
      indexHistory: [...indexHistory, lastId],
      limit: limit,
      hasMore: hasMore,
    );
  }

  // Navegar a la página anterior
  PaginationState previousPage() {
    if (indexHistory.isEmpty) return this;

    final newHistory = List<String>.from(indexHistory);
    newHistory.removeLast();

    return PaginationState(
      indexHistory: newHistory,
      limit: limit,
      hasMore: true, // Siempre hay más al retroceder
    );
  }

  // Cambiar el límite de elementos por página
  PaginationState changeLimit(int newLimit) {
    return PaginationState(
      indexHistory: const [],
      limit: newLimit,
      hasMore: true,
    );
  }

  // Actualizar hasMore basado en el número de resultados
  PaginationState updateHasMore(int resultCount) {
    return PaginationState(
      indexHistory: indexHistory,
      limit: limit,
      hasMore: resultCount >= limit,
    );
  }

  // Obtener el index actual (último del historial o null si es primera página)
  String? get currentIndex => indexHistory.isEmpty ? null : indexHistory.last;

  // Verificar si estamos en la primera página
  bool get isFirstPage => indexHistory.isEmpty;

  // Resetear paginación
  PaginationState reset() {
    return PaginationState(
      indexHistory: const [],
      limit: limit,
      hasMore: true,
    );
  }
}
