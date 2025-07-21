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
  bool isLoading = false;
  String? errorMessage;
  String? errorMessageShared;

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<void> fetchWorkspaces() async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

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
      notifyListeners();
    }
  }
}
