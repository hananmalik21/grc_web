import 'package:digify_grc_suite/digify_grc_suite.dart' as grc_suite;
import 'package:digify_grc_suite/grc/presentation/grc_ui/router/app_nav_item.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/auth/data/datasources/auth_local_storage.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _DigifyHrAuthTokenStorage implements grc_suite.AuthTokenStorage {
  _DigifyHrAuthTokenStorage(this._storage);

  final AuthLocalStorage _storage;

  @override
  Future<String?> readAccessToken() => _storage.getToken();
}

bool _canAccessGrcNavItem(AppNavItem item) {
  if (PermissionService.instance.isBypassAllPermissions) return true;
  return switch (item) {
    AppNavItem.dashboard => PermissionService.instance.can(
      PermKeys.grcDashboardView,
    ),
    AppNavItem.library => PermissionService.instance.can(
      PermKeys.grcLibraryView,
    ),
    AppNavItem.assets => PermissionService.instance.can(PermKeys.grcAssetsView),
    AppNavItem.risks => PermissionService.instance.can(PermKeys.grcRisksView),
    AppNavItem.assessments => PermissionService.instance.can(
      PermKeys.grcAssessmentsView,
    ),
    AppNavItem.controls => PermissionService.instance.can(
      PermKeys.grcControlsView,
    ),
    AppNavItem.tprm => PermissionService.instance.can(PermKeys.grcTprmView),
    AppNavItem.programs => PermissionService.instance.can(
      PermKeys.grcProgramsView,
    ),
    AppNavItem.reviewProgress => PermissionService.instance.can(
      PermKeys.grcReviewProgressView,
    ),
  };
}

List<Override> buildGrcSuiteHostOverrides() => [
  grc_suite.activeEnterpriseIdProvider.overrideWith(
    (ref) => ref.watch(activeEnterpriseIdProvider),
  ),
  ...grc_suite.buildGrcNetworkHostOverrides(
    baseUrl: (ref) => ApiConfig.baseUrl,
    authStorage: (ref) =>
        _DigifyHrAuthTokenStorage(ref.read(authLocalStorageProvider)),
  ),
  grc_suite.buildGrcNavVisibilityHostOverride(_canAccessGrcNavItem),
];
