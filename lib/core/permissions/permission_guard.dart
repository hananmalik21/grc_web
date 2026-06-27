class PermissionGuard {
  static const String globalWildcard = '*';

  PermissionGuard(Iterable<String> permissions) : _permissions = permissions.toSet();

  final Set<String> _permissions;

  bool get hasGlobalWildcard => _permissions.contains(globalWildcard);

  bool allows(String key) {
    if (_permissions.contains(globalWildcard)) return true;
    if (_permissions.contains(key)) return true;

    final parts = key.split('.');
    for (var i = parts.length - 1; i > 0; i--) {
      final prefix = parts.sublist(0, i).join('.');
      if (_permissions.contains('$prefix.*')) return true;
    }

    return false;
  }
}
