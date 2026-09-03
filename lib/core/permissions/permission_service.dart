import 'dart:developer' as developer;

import 'package:digify_core/permissions/permission_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';

export 'package:digify_core/permissions/permission_service.dart';

final permissionsBootstrapProvider = Provider<void>((ref) {
  ref.listen<AuthState>(authProvider, (_, next) {
    if (!next.isAuthenticated) {
      PermissionService.instance.clear();
      return;
    }

    final keys = next.permissions
        .map((key) => key.toLowerCase().trim())
        .where((key) => key.isNotEmpty)
        .toList();
    developer.log(
      'Permission keys from login: $keys',
      name: 'auth.permissions',
    );
    if (keys.isEmpty) {
      PermissionService.instance.clear();
      return;
    }
    PermissionService.instance.syncFromKeys(keys);
  }, fireImmediately: true);
});
