import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/form_workspace.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormWorkspacePage extends StatefulWidget {
  final String? idWorkspace;
  const FormWorkspacePage({
    super.key,
    this.idWorkspace,
  });

  @override
  State<FormWorkspacePage> createState() => _FormWorkspacePageState();
}

class _FormWorkspacePageState extends State<FormWorkspacePage> {
  late Future<Result<Workspace>>? _workspaceFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.idWorkspace != null) {
      _workspaceFuture = _fetchWorkspace();
    }
  }

  Future<Result<Workspace>> _fetchWorkspace() async {
    final provider = context.read<WorkspaceProvider>();
    return await provider.getWorkspaceById(widget.idWorkspace!);
  }

  Future<void> _handleSubmit(BuildContext context, Workspace workspace) async {
    setState(() => _isLoading = true);

    final provider = context.read<WorkspaceProvider>();
    if (widget.idWorkspace != null) {
      await provider.updateWorkspace(workspace);
    } else {
      final error = await provider.createWorkspace(workspace);
      if (error == null && context.mounted && widget.idWorkspace == null) {
        context.pop();
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.idWorkspace != null
        ? "Editar espacio de trabajo"
        : "Crear espacio de trabajo";
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    if (widget.idWorkspace == null) {
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
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize, title),
      );
    }

    return BaseContainer(
      margin: EdgeInsets.all(widget.idWorkspace != null ? 0 : 10),
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
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: widget.idWorkspace != null
          ? FutureBuilder<Result<Workspace>>(
              future: _workspaceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!.isSuccess) {
                  return Center(
                    child: Text(
                      snapshot.data?.message ??
                          'Error cargando espacio de trabajo',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final workspace = snapshot.data!.value!;
                return FormWorkspace(
                  title: title,
                  idWorkspace: widget.idWorkspace,
                  name: workspace.name,
                  type: workspace.type,
                  isLoading: _isLoading,
                  onSubmit: (workspace) => _handleSubmit(context, workspace),
                );
              },
            )
          : FormWorkspace(
              title: title,
              idWorkspace: widget.idWorkspace,
              isLoading: _isLoading,
              onSubmit: (workspace) => _handleSubmit(context, workspace),
            ),
    );
  }
}
