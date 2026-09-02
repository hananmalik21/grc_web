class ScanHistoryModel {
  final String scanId;
  final String dateTime;
  final String duration;
  final int newFindings;
  final int fixedFindings;
  final int totalFindings;
  final int resourcesScanned;
  final String status;
  final bool isLatest;

  const ScanHistoryModel({
    required this.scanId,
    required this.dateTime,
    required this.duration,
    required this.newFindings,
    required this.fixedFindings,
    required this.totalFindings,
    required this.resourcesScanned,
    required this.status,
    this.isLatest = false,
  });
}
