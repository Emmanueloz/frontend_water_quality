// domain/models/guest.dart
class Guest {
  final String id;
  final String name;
  final String email;
  final String role;

  Guest({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    // Manejar diferentes formatos de datos JSON
    String getStringValue(String key) {
      final value = json[key];
      if (value == null) return '';
      return value.toString();
    }

    // Función para obtener el nombre en diferentes formatos posibles
    String getName() {
      // Intentar diferentes campos para el nombre
      final possibleNameFields = ['name', 'username', 'full_name', 'fullName', 'first_name', 'firstName', 'display_name', 'displayName'];
      
      for (final field in possibleNameFields) {
        final value = json[field];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      
      // Si no encuentra nombre, intentar construir desde first_name y last_name
      final firstName = json['first_name'] ?? json['firstName'] ?? '';
      final lastName = json['last_name'] ?? json['lastName'] ?? '';
      
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        final fullName = '$firstName $lastName'.trim();
        return fullName;
      }
      
      // Si no hay nombre, usar el email como fallback
      final email = getStringValue('email');
      if (email.isNotEmpty) {
        final emailName = email.split('@').first;
        return emailName;
      }
      
      return 'Sin nombre';
    }

    // Función para obtener el rol en diferentes formatos
    String getRole() {
      final possibleRoleFields = ['role', 'rol', 'user_role', 'userRole'];
      
      for (final field in possibleRoleFields) {
        final value = json[field];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      
      return 'visitor'; // Rol por defecto
    }

    // Función para obtener el ID
    String getId() {
      final possibleIdFields = ['id', 'uid', 'user_id', 'userId'];
      
      for (final field in possibleIdFields) {
        final value = json[field];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      
      // Si no encuentra ID, intentar usar el email como identificador temporal
      final email = getStringValue('email');
      if (email.isNotEmpty) {
        return email; // Usar email como ID temporal
      }
      
      return ''; // ID vacío si no se encuentra
    }

    return Guest(
      id: getId(),
      name: getName(),
      email: getStringValue('email'),
      role: getRole(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
      };

  @override
  String toString() {
    return 'Guest(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Guest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
