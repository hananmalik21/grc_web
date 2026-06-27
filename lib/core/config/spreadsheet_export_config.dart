class SpreadsheetExportConfig {
  const SpreadsheetExportConfig({
    required this.endpoint,
    required this.queryParametersBuilder,
    required this.fileNameBuilder,
    required this.successMessage,
    required this.failureMessage,
  });

  final String endpoint;
  final Map<String, String> Function(int enterpriseId) queryParametersBuilder;
  final String Function(int enterpriseId) fileNameBuilder;
  final String successMessage;
  final String failureMessage;
}
