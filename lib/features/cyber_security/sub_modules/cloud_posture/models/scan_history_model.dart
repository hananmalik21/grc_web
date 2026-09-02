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

  static List<ScanHistoryModel> getMockScanHistory() => const [
    ScanHistoryModel(
      scanId: 'SCN-8847',
      dateTime: '2026-06-28 16:30',
      duration: '4m 12s',
      newFindings: 2,
      fixedFindings: -5,
      totalFindings: 312,
      resourcesScanned: 1533,
      status: 'completed',
      isLatest: true,
    ),
    ScanHistoryModel(
      scanId: 'SCN-8846',
      dateTime: '2026-06-27 16:30',
      duration: '4m 08s',
      newFindings: 5,
      fixedFindings: -3,
      totalFindings: 315,
      resourcesScanned: 1521,
      status: 'completed',
    ),
    ScanHistoryModel(
      scanId: 'SCN-8845',
      dateTime: '2026-06-26 16:30',
      duration: '3m 55s',
      newFindings: 1,
      fixedFindings: -7,
      totalFindings: 313,
      resourcesScanned: 1519,
      status: 'completed',
    ),
    ScanHistoryModel(
      scanId: 'SCN-8844',
      dateTime: '2026-06-25 16:30',
      duration: '4m 21s',
      newFindings: 8,
      fixedFindings: -2,
      totalFindings: 319,
      resourcesScanned: 1585,
      status: 'completed',
    ),
    ScanHistoryModel(
      scanId: 'SCN-8843',
      dateTime: '2026-06-24 16:30',
      duration: '3m 47s',
      newFindings: 3,
      fixedFindings: -4,
      totalFindings: 313,
      resourcesScanned: 1498,
      status: 'completed',
    ),
    ScanHistoryModel(
      scanId: 'SCN-8842',
      dateTime: '2026-06-23 16:30',
      duration: '4m 03s',
      newFindings: 0,
      fixedFindings: -8,
      totalFindings: 314,
      resourcesScanned: 1492,
      status: 'completed',
    ),
    ScanHistoryModel(
      scanId: 'SCN-8841',
      dateTime: '2026-06-22 16:30',
      duration: '4m 19s',
      newFindings: 6,
      fixedFindings: -1,
      totalFindings: 322,
      resourcesScanned: 1488,
      status: 'completed',
    ),
  ];
}
