import 'package:digify_enterprise_structure/digify_enterprise_structure.dart'
    as es;
import 'package:grc/core/config/spreadsheet_export_config.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart' as hr;
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/auth/data/datasources/auth_local_storage.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _DigifyHrAuthTokenStorage implements es.AuthTokenStorage {
  _DigifyHrAuthTokenStorage(this._storage);

  final AuthLocalStorage _storage;

  @override
  Future<String?> readAccessToken() => _storage.getToken();
}

class _HostEsSpreadsheetExportNotifier extends es.EsSpreadsheetExportNotifier {
  @override
  Future<void> export(
    BuildContext context, {
    required es.EsSpreadsheetExportConfig config,
    required int? enterpriseId,
  }) async {
    final localizations = AppLocalizations.of(context)!;

    if (enterpriseId == null) {
      ToastService.warning(context, localizations.selectEnterpriseFirst);
      return;
    }

    if (state) return;

    state = true;
    try {
      final hostConfig = SpreadsheetExportConfig(
        endpoint: config.endpoint,
        queryParametersBuilder: config.queryParametersBuilder,
        fileNameBuilder: config.fileNameBuilder,
        successMessage: config.successMessage,
        failureMessage: config.failureMessage,
      );
      final saved = await ref
          .read(hr.spreadsheetExportServiceProvider)
          .exportAndSave(config: hostConfig, enterpriseId: enterpriseId);
      if (!context.mounted) return;

      if (saved) {
        ToastService.success(context, hostConfig.successMessage);
      } else {
        ToastService.error(context, hostConfig.failureMessage);
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, config.failureMessage);
      }
    } finally {
      state = false;
    }
  }
}

List<Override> buildEnterpriseStructureHostOverrides() => [
  es.activeEnterpriseIdProvider.overrideWith(
    (ref) => ref.watch(activeEnterpriseIdProvider),
  ),
  es.enterprisesCacheProvider.overrideWith(
    (ref) => ref.watch(enterprisesCacheProvider) ?? const [],
  ),
  ...es.buildEsNetworkHostOverrides(
    baseUrl: (ref) => ApiConfig.baseUrl,
    authStorage: (ref) =>
        _DigifyHrAuthTokenStorage(ref.read(authLocalStorageProvider)),
  ),
  es.spreadsheetExportProvider.overrideWith(
    _HostEsSpreadsheetExportNotifier.new,
  ),
  es.esShowEnterpriseSelectorProvider.overrideWith(
    (ref) => ref.watch(showEnterpriseSelectorProvider),
  ),
  es.esEnterprisesCacheStateProvider.overrideWith((ref) {
    final hrState = ref.watch(enterprisesCacheStateProvider);
    return es.EnterprisesState(
      enterprises: hrState.enterprises
          .map(
            (e) => es.Enterprise(
              id: e.id,
              name: e.name,
              code: e.code,
              isActive: e.isActive,
            ),
          )
          .toList(),
      isLoading: hrState.isLoading,
      errorMessage: hrState.errorMessage,
      hasError: hrState.hasError,
    );
  }),
];
