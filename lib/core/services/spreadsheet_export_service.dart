import 'package:grc/core/config/spreadsheet_export_config.dart';
import 'package:grc/core/data/datasources/spreadsheet_export_remote_data_source.dart';
import 'package:grc/core/utils/spreadsheet_export_file_saver.dart';

class SpreadsheetExportService {
  const SpreadsheetExportService({required SpreadsheetExportRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final SpreadsheetExportRemoteDataSource _remoteDataSource;

  Future<bool> exportAndSave({required SpreadsheetExportConfig config, required int enterpriseId}) async {
    final bytes = await _remoteDataSource.fetchExportBytes(
      endpoint: config.endpoint,
      queryParameters: config.queryParametersBuilder(enterpriseId),
    );
    if (bytes.isEmpty) return false;

    final fileName = config.fileNameBuilder(enterpriseId);
    return saveSpreadsheetExportFile(bytes: bytes, fileName: fileName);
  }
}
