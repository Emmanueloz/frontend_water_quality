class RouteProperties {
  final String name;
  final String path;
  final String? pathRoot;

  RouteProperties({
    required this.name,
    required this.path,
    this.pathRoot,
  });
}
