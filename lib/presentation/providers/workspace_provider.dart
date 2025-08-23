import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WorkspaceProvider {
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

  Future<Result<Workspace>> getWorkspaceById(String id) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _workspaceRepo.getById(_authProvider!.token!, id);
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
    if (_authProvider == null || _authProvider!.token == null) {
      return "User not authenticated";
    }

    try {
      final result =
          await _workspaceRepo.create(_authProvider!.token!, workspace);
      return result.message;
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  Future<(bool success, String? error)> updateWorkspace(
      Workspace workspace) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return (false, "User not authenticated");
    }

    try {
      final result =
          await _workspaceRepo.update(_authProvider!.token!, workspace);
      return (result.isSuccess, result.isSuccess ? null : result.message);
    } catch (e) {
      return (false, e.toString());
    }
  }
}
