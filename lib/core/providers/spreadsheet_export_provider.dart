import 'package:grc/core/config/spreadsheet_export_config.dart';
import 'package:grc/core/data/datasources/spreadsheet_export_remote_data_source.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/spreadsheet_export_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _spreadsheetExportApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _spreadsheetExportRemoteDataSourceProvider = Provider<SpreadsheetExportRemoteDataSource>((ref) {
  return SpreadsheetExportRemoteDataSourceImpl(apiClient: ref.watch(_spreadsheetExportApiClientProvider));
});

final spreadsheetExportServiceProvider = Provider<SpreadsheetExportService>((ref) {
  return SpreadsheetExportService(remoteDataSource: ref.watch(_spreadsheetExportRemoteDataSourceProvider));
});

class SpreadsheetExportNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> export(
    BuildContext context, {
    required SpreadsheetExportConfig config,
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
      final saved = await ref
          .read(spreadsheetExportServiceProvider)
          .exportAndSave(config: config, enterpriseId: enterpriseId);
      if (!context.mounted) return;

      if (saved) {
        ToastService.success(context, config.successMessage);
      } else {
        ToastService.error(context, config.failureMessage);
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

final spreadsheetExportProvider = NotifierProvider<SpreadsheetExportNotifier, bool>(SpreadsheetExportNotifier.new);
