import 'dart:developer' as developer;

import 'package:grc/core/config/app_config.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/security_manager/domain/models/user_detail_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'perm_module.dart';
import 'permission_guard.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService _instance = PermissionService._();
  static PermissionService get instance => _instance;

  factory PermissionService() => _instance;

  bool get isBypassAllPermissions => kDebugMode && AppConfig.debugBypassAllPermissions;

  bool get hasFullAccess => _guard.hasGlobalWildcard;

  PermissionGuard _guard = PermissionGuard(const <String>[]);

  void init(List<String> permissions) {
    assert(permissions.isNotEmpty, 'Call clear() instead of init() with an empty list.');
    _guard = PermissionGuard(permissions);
  }

  bool can(String key) => isBypassAllPermissions || _guard.allows(key);

  void clear() {
    _guard = PermissionGuard(const <String>[]);
  }
}

extension PermissionServiceModuleCheck on PermissionService {
  /// Returns true if the user can see at least one submodule in [module].
  bool canSeeModule(PermModule module) {
    if (can(module.wildcard)) return true;
    return module.subModules.any(canSeeSubModule);
  }

  /// Returns true if the user holds the submodule wildcard or any of its actions.
  bool canSeeSubModule(PermSubModule sub) {
    if (can(sub.wildcard)) return true;
    return sub.actions.any((a) => can(sub.action(a)));
  }
}

/// Riverpod bootstrap provider.
///
/// Watch this **once** from the root authenticated widget (e.g. `AppLayout`)
/// to automatically init and clear `PermissionService` as auth state changes.
///
/// ```dart
/// // In AppLayout.build:
/// ref.watch(permissionsBootstrapProvider);
/// ```
final permissionsBootstrapProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<UserDetailData?>>(currentUserProvider, (_, next) {
    next.when(
      data: (user) {
        if (user == null) {
          PermissionService.instance.clear();
          return;
        }

        final keys = user.permissionKeys.map((k) => k.toLowerCase().trim()).where((k) => k.isNotEmpty).toList();
        developer.log('Permission keys from API: $keys', name: 'auth.permissions');

        if (keys.isEmpty) {
          // Backend returned no permissions — treat as unauthorized.
          PermissionService.instance.clear();
          return;
        }

        PermissionService.instance.init(keys);
      },
      loading: () {},
      error: (_, _) => PermissionService.instance.clear(),
    );
  });
});
