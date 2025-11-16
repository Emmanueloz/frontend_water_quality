enum AppRoles {
  admin,
  client,
  unknown,
}

extension AppRolesExtension on AppRoles {
  String get nameSpanish {
    switch (this) {
      case AppRoles.admin:
        return 'Administrador';
      case AppRoles.client:
        return 'Cliente';
      case AppRoles.unknown:
        return 'Desconocido';
    }
  }
}
