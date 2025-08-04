import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WorkspaceProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final WorkspaceRepo _workspaceRepo;
  WorkspaceProvider(this._workspaceRepo, this._authProvider);

  List<Workspace> workspaces = [];
  List<Workspace> workspacesShared = [];
  List<Workspace> workspacesAll = [];
  Workspace? currentWorkspace;
  bool isLoading = false;
  bool isLoadingShared = false;
  bool isLoadingAll = false;
  bool isLoadingForm = false;
  bool recharge = true;
  bool rechargeShare = true;
  bool rechargeAll = true;
  String? errorMessage;
  String? errorMessageShared;
  String? errorMessageAll;
  String? errorMessageForm;

  void clean() {
    workspaces = [];
    workspacesShared = [];
    workspacesAll = [];
    currentWorkspace = null;
    isLoading = false;
    isLoadingForm = false;
    recharge = true;
    errorMessage = null;
    errorMessageShared = null;
    errorMessageAll = null;
    errorMessageForm = null;
  }

  void cleanForm() {
    currentWorkspace = null;
    errorMessageForm = null;
  }

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

  Future<void> fetchWorkspacesUser() async {
    await fetchWorkspaces();
    await fetchWorkspacesShare();
    await fetchWorkspacesAll();
  }

  Future<void> fetchWorkspaces({bool isRecharge = false}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    if (isRecharge) {
      recharge = true;
      notifyListeners();
    }

    if (!recharge) return;

    isLoading = true;
    notifyListeners();

    try {
      print("Fetching workspaces...");
      final result = await _workspaceRepo.getAll(_authProvider!.token!);
      if (!result.isSuccess) {
        errorMessage = result.message;
        notifyListeners();
        return;
      }

      workspaces = result.value ?? [];
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      recharge = false;
      notifyListeners();
    }
  }

  Future<void> fetchWorkspacesShare({bool isRecharge = false}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageShared = "User not authenticated";
      notifyListeners();
      return;
    }

    if (isRecharge) {
      rechargeShare = true;
      notifyListeners();
    }

    if (!rechargeShare) return;

    isLoadingShared = true;
    notifyListeners();
    try {
      final sharedResult =
          await _workspaceRepo.getShared(_authProvider!.token!);
      if (!sharedResult.isSuccess) {
        errorMessageShared = sharedResult.message;
        notifyListeners();
        return;
      }

      workspacesShared = sharedResult.value ?? [];
      errorMessageShared = null;
    } catch (e) {
      errorMessageShared = e.toString();
    } finally {
      isLoadingShared = false;
      rechargeShare = false;
      notifyListeners();
    }
  }

  Future<void> fetchWorkspacesAll({bool isRecharge = false}) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageAll = "User not authenticated";
      notifyListeners();
      return;
    }

    if (_authProvider?.user?.rol != AppRoles.admin) {
      print("User is not admin");
      workspacesAll = [];
      errorMessageAll = null;
      notifyListeners();
      return;
    }

    if (isRecharge) {
      rechargeAll = true;
      notifyListeners();
    }

    if (!rechargeAll) return;

    isLoadingAll = true;
    notifyListeners();
    try {
      final allResult = await _workspaceRepo.getFullAll(_authProvider!.token!);
      print("Fetched all workspaces: ${allResult.isSuccess}");
      if (!allResult.isSuccess) {
        errorMessageAll = allResult.message;
        return;
      }

      workspacesAll = allResult.value ?? [];
      errorMessageAll = null;
    } catch (e) {
      errorMessageAll = e.toString();
    } finally {
      isLoadingAll = false;
      rechargeAll = false;
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
