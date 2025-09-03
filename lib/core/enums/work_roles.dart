enum WorkRole { visitor, manager, administrator, owner, unknown }

extension WorkRoleExtension on WorkRole {
  String get label {
    switch (this) {
      case WorkRole.visitor:
        return 'Visitante';
      case WorkRole.manager:
        return 'Gerente';
      case WorkRole.administrator:
        return 'Administrador';
      case WorkRole.owner:
        return 'Propietario';
      case WorkRole.unknown:
        return 'Desconocido';
    }
  }

  static WorkRole? fromName(String? name) {
    switch (name) {
      case 'visitor':
        return WorkRole.visitor;
      case 'manager':
        return WorkRole.manager;
      case 'administrator':
        return WorkRole.administrator;
      case 'owner':
        return WorkRole.owner;
      case 'unknown':
        return WorkRole.unknown;
      default:
        return null;
    }
  }
}
