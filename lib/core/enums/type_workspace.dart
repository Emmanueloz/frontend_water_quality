enum TypeWorkspace {
  public,
  private,
}

extension TypeWorkspaceExtension on TypeWorkspace {
  String get nameSpanish {
    switch (this) {
      case TypeWorkspace.public:
        return "Publico";
      case TypeWorkspace.private:
        return "Privado";
    }
  }

  static TypeWorkspace fromName(String name) {
    switch (name) {
      case "public":
        return TypeWorkspace.public;
      case "private":
        return TypeWorkspace.private;
      default:
        throw ArgumentError("Unknown workspace type: $name");
    }
  }
}
