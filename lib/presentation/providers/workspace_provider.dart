import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WorkspaceProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final WorkspaceRepo _workspaceRepo;

  // Flags para control de recarga
  bool _shouldReloadList = true;
  final Map<String, bool> _shouldReloadWorkspace = {};

  WorkspaceProvider(this._workspaceRepo, this._authProvider);

  // Getters para los flags
  bool get shouldReloadList => _shouldReloadList;
  bool shouldReloadWorkspace(String id) => _shouldReloadWorkspace[id] ?? true;

  // Métodos para marcar recargas
  void markListForReload() {
    _shouldReloadList = true;
    notifyListeners();
  }

  void markWorkspaceForReload(String id) {
    _shouldReloadWorkspace[id] = true;
    notifyListeners();
  }

  // Métodos para confirmar recargas completadas
  void confirmListReloaded() {
    _shouldReloadList = false;
  }

  void confirmWorkspaceReloaded(String id) {
    _shouldReloadWorkspace.remove(id);
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
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getWorkspaces() async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _workspaceRepo.getAll(_authProvider!.token!);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getSharedWorkspaces() async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _workspaceRepo.getShared(_authProvider!.token!);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Workspace>>> getAllWorkspaces() async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _workspaceRepo.getFullAll(_authProvider!.token!);
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
