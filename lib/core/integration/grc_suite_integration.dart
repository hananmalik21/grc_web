import 'package:digify_grc_suite/digify_grc_suite.dart' as grc_suite;
import 'package:grc/core/network/api_config.dart';
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

/// Wires [digify_hr_system] auth, API URL, and enterprise scope into [digify_grc_suite].
List<Override> buildGrcSuiteHostOverrides() => [
      grc_suite.activeEnterpriseIdProvider.overrideWith(
        (ref) => ref.watch(activeEnterpriseIdProvider),
      ),
      grc_suite.apiBaseUrlProvider.overrideWith((ref) => ApiConfig.baseUrl),
      grc_suite.authTokenStorageProvider.overrideWith(
        (ref) => _DigifyHrAuthTokenStorage(ref.watch(authLocalStorageProvider)),
      ),
    ];
