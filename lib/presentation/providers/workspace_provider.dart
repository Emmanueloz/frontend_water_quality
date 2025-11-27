import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/pagination_state.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WorkspaceProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final WorkspaceRepo _workspaceRepo;

  // Flags para control de recarga por tipo
  final Map<String, bool> _shouldReloadByType = {};
  final Map<String, bool> _shouldReloadWorkspace = {};

  // Estados de paginación por tipo
  final Map<ListWorkspaces, PaginationState> _paginationStates = {
    ListWorkspaces.mine: const PaginationState(),
    ListWorkspaces.shared: const PaginationState(),
    ListWorkspaces.public: const PaginationState(),
    ListWorkspaces.all: const PaginationState(),
  };

  WorkspaceProvider(this._workspaceRepo, this._authProvider);

  // Getters para los flags
  bool shouldReloadType(String type) => _shouldReloadByType[type] ?? true;
  bool shouldReloadWorkspace(String id) => _shouldReloadWorkspace[id] ?? true;

  // Métodos para marcar recargas
  void markListForReload({String? type}) {
    if (type != null) {
      _shouldReloadByType[type] = true;
    } else {
      // Marcar todos los tipos para recarga
      _shouldReloadByType['mine'] = true;
      _shouldReloadByType['shared'] = true;
      _shouldReloadByType['public'] = true;
      _shouldReloadByType['all'] = true;
    }
    notifyListeners();
  }

  void markWorkspaceForReload(String id) {
    _shouldReloadWorkspace[id] = true;
    notifyListeners();
  }

  // Métodos para confirmar recargas completadas
  void confirmListReloaded({String? type}) {
    if (type != null) {
      _shouldReloadByType[type] = false;
    } else {
      _shouldReloadByType.clear();
    }
  }

  void confirmWorkspaceReloaded(String id) {
    _shouldReloadWorkspace.remove(id);
  }

  // Getter para obtener el estado de paginación
  PaginationState getPaginationState(ListWorkspaces type) {
    return _paginationStates[type]!;
  }

  // Navegar a la siguiente página
  Future<void> nextPage(ListWorkspaces type, String lastWorkspaceId) async {
    final currentState = _paginationStates[type]!;
    _paginationStates[type] = currentState.nextPage(lastWorkspaceId);
    notifyListeners();
  }

  // Navegar a la página anterior
  Future<void> previousPage(ListWorkspaces type) async {
    final currentState = _paginationStates[type]!;
    if (!currentState.isFirstPage) {
      _paginationStates[type] = currentState.previousPage();
      notifyListeners();
    }
  }

  // Cambiar el límite de elementos por página
  Future<void> changeLimit(ListWorkspaces type, int newLimit) async {
    _paginationStates[type] = _paginationStates[type]!.changeLimit(newLimit);
    notifyListeners();
  }

  // Actualizar hasMore después de cargar datos
  void updatePaginationHasMore(ListWorkspaces type, int resultCount) {
    _paginationStates[type] =
        _paginationStates[type]!.updateHasMore(resultCount);
  }

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<Result<Workspace>> getWorkspaceById(String id) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _workspaceRepo.getById(_authProvider!.token!, id);
      if (id != await LocalStorageService.get(StorageKey.workspaceId)) {
        LocalStorageService.save(StorageKey.workspaceId, id);
        LocalStorageService.remove(StorageKey.meterId);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getWorkspaces(
      {String? index, int? limit}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final paginationState = _paginationStates[ListWorkspaces.mine]!;
      final result = await _workspaceRepo.getAll(
        _authProvider!.token!,
        index: index ?? paginationState.currentIndex,
        limit: limit ?? paginationState.limit,
      );

      if (result.isSuccess) {
        updatePaginationHasMore(ListWorkspaces.mine, result.value!.length);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getPublicWorkspaces(
      {String? index, int? limit}) async {
    try {
      final paginationState = _paginationStates[ListWorkspaces.public]!;
      final result = await _workspaceRepo.getPublic(
        index: index ?? paginationState.currentIndex,
        limit: limit ?? paginationState.limit,
      );

      if (result.isSuccess) {
        updatePaginationHasMore(ListWorkspaces.public, result.value!.length);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getSharedWorkspaces(
      {String? index, int? limit}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final paginationState = _paginationStates[ListWorkspaces.shared]!;
      final result = await _workspaceRepo.getShared(
        _authProvider!.token!,
        index: index ?? paginationState.currentIndex,
        limit: limit ?? paginationState.limit,
      );

      if (result.isSuccess) {
        updatePaginationHasMore(ListWorkspaces.shared, result.value!.length);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getAllWorkspaces(
      {String? index, int? limit}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final paginationState = _paginationStates[ListWorkspaces.all]!;
      final result = await _workspaceRepo.getFullAll(
        _authProvider!.token!,
        index: index ?? paginationState.currentIndex,
        limit: limit ?? paginationState.limit,
      );

      if (result.isSuccess) {
        updatePaginationHasMore(ListWorkspaces.all, result.value!.length);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<String?> createWorkspace(Workspace workspace) async {
    if (_authProvider?.token == null) return "User not authenticated";

    try {
      final result =
          await _workspaceRepo.create(_authProvider!.token!, workspace);
      if (result.isSuccess) {
        markListForReload(); // Marcar para recargar la lista después de crear
      }
      return result.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<(bool success, String? error)> updateWorkspace(
      Workspace workspace) async {
    if (_authProvider?.token == null) return (false, "User not authenticated");

    try {
      final result =
          await _workspaceRepo.update(_authProvider!.token!, workspace);
      if (result.isSuccess) {
        markWorkspaceForReload(workspace.id!); // Marcar workspace específico
        markListForReload(); // Marcar lista para actualizar
      }
      return (result.isSuccess, result.isSuccess ? null : result.message);
    } catch (e) {
      return (false, e.toString());
    }
  }
}
