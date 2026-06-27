import 'package:flutter/widgets.dart';

import 'permission_service.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({super.key, required this.permKey, required this.child, this.fallback});

  final String permKey;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (PermissionService.instance.can(permKey)) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
