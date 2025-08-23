import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/form_workspace.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormWorkspacePage extends StatelessWidget {
  final String? idWorkspace;
  const FormWorkspacePage({
    super.key,
    this.idWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    String title = idWorkspace != null
        ? "Editar espacio de trabajo"
        : "Crear espacio de trabajo";
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    if (idWorkspace == null) {
      return Layout(
        title: title,
        builder: (context, screenSize) {
          return _builderMain(context, screenSize, title);
        },
      );
    }

    return _builderMain(context, screenSize, title);
  }

  Widget _builderMain(
      BuildContext context, ScreenSize screenSize, String title) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize, title),
      );
    }

    return BaseContainer(
      margin: EdgeInsets.all(idWorkspace != null ? 0 : 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize, title),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize, String title) {
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Consumer<WorkspaceProvider>(
        builder: (context, workspaceProvider, child) {
          return FormWorkspace(
            title: title,
            idWorkspace: idWorkspace,
            name: workspaceProvider.currentWorkspace?.name,
            type: workspaceProvider.currentWorkspace?.type,
            errorMessage: workspaceProvider.errorMessageForm,
            isLoading: workspaceProvider.isLoadingForm,
            onSubmit: (Workspace workspace) async {
              if (idWorkspace != null) {
                print("Actualizando espacio de trabajo");
                await workspaceProvider.updateWorkspace(workspace);
              } else {
                final errorMessage =
                    await workspaceProvider.createWorkspace(workspace);
                if (errorMessage == null && context.mounted) {
                  context.pop();
                }
              }
            },
          );
        },
      ),
    );
  }
}
