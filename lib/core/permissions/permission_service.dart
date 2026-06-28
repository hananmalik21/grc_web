import 'dart:developer' as developer;

import 'package:digify_core/permissions/permission_service.dart';
import 'package:digify_security_console/digify_security_console.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/providers/current_user_provider.dart';

export 'package:digify_core/permissions/permission_service.dart';

final permissionsBootstrapProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<UserDetailData?>>(currentUserProvider, (_, next) {
    next.when(
      data: (user) {
        if (user == null) {
          PermissionService.instance.clear();
          return;
        }

        final keys = user.permissionKeys
            .map((k) => k.toLowerCase().trim())
            .where((k) => k.isNotEmpty)
            .toList();
        developer.log(
          'Permission keys from API: $keys',
          name: 'auth.permissions',
        );

        if (keys.isEmpty) {
          PermissionService.instance.clear();
          return;
        }

        PermissionService.instance.syncFromKeys(keys);
      },
      loading: () {},
      error: (_, _) => PermissionService.instance.clear(),
    );
  });
});
