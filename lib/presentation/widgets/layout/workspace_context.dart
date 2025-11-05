import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';

class WorkspaceContext extends InheritedWidget {
  final Workspace? workspace;

  const WorkspaceContext({
    super.key,
    required this.workspace,
    required super.child,
  });

  static WorkspaceContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WorkspaceContext>();
  }

  @override
  bool updateShouldNotify(WorkspaceContext oldWidget) {
    return workspace != oldWidget.workspace;
  }
}