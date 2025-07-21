import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WorkspaceProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final WorkspaceRepo _workspaceRepo;
  WorkspaceProvider(this._workspaceRepo, this._authProvider);

  List<Workspace> workspaces = [];
  List<Workspace> workspacesShared = [];
  Workspace? currentWorkspace;
  bool isLoading = false;
  bool isLoadingForm = false;
  bool recharge = true;
  String? errorMessage;
  String? errorMessageShared;
  String? errorMessageForm;

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<void> fetchWorkspace(String idWorkspace) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    isLoading = true;
    currentWorkspace = null;
    notifyListeners();

    try {
      final result =
          await _workspaceRepo.getById(_authProvider!.token!, idWorkspace);
      if (!result.isSuccess) {
        errorMessage = result.message;
        return;
      }

      currentWorkspace = result.value;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWorkspaces() async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    if (!recharge) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await _workspaceRepo.getAll(_authProvider!.token!);
      if (!result.isSuccess) {
        errorMessage = result.message;
        return;
      }

      workspaces = result.value ?? [];
      errorMessage = null;

      final sharedResult =
          await _workspaceRepo.getShared(_authProvider!.token!);
      if (!sharedResult.isSuccess) {
        errorMessageShared = sharedResult.message;
        return;
      }

      workspacesShared = sharedResult.value ?? [];
      errorMessageShared = null;
    } catch (e) {
      errorMessage = e.toString();
      errorMessageShared = e.toString();
    } finally {
      isLoading = false;
      recharge = false;
      notifyListeners();
    }
  }

  Future<bool> createWorkspace(Workspace workspace) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageForm = "User not authenticated";
      notifyListeners();
      return false;
    }

    isLoadingForm = true;
    notifyListeners();

    try {
      print(workspace.toJson());
      final result =
          await _workspaceRepo.create(_authProvider!.token!, workspace);

      print(result);
      if (!result.isSuccess) {
        errorMessageForm = result.message;
        return false;
      }

      recharge = true;
      errorMessageForm = null;
      isLoadingForm = false;
      notifyListeners();
      await fetchWorkspaces();
      return result.isSuccess;
    } catch (e) {
      errorMessageForm = e.toString();
      isLoadingForm = false;
      recharge = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateWorkspace(Workspace workspace) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageForm = "User not authenticated";
      notifyListeners();
      return false;
    }

    isLoadingForm = true;
    notifyListeners();

    try {
      final result =
          await _workspaceRepo.update(_authProvider!.token!, workspace);

      if (!result.isSuccess) {
        errorMessageForm = result.message;
        return false;
      }

      recharge = true;
      errorMessageForm = null;
      isLoadingForm = false;
      notifyListeners();
      await fetchWorkspaces();
      if (currentWorkspace != null) {
        currentWorkspace = workspace;
      }
      return result.isSuccess;
    } catch (e) {
      errorMessageForm = e.toString();
      isLoadingForm = false;
      recharge = false;
      notifyListeners();
      return false;
    }
  }
}
