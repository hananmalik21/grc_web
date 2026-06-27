import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';

/// Domain project for a simple position reference
class SimplePosition {
  final String id;
  final String code;
  final String titleEnglish;

  const SimplePosition({required this.id, required this.code, required this.titleEnglish});
}

/// Domain entity for hierarchical reporting relationships
class ReportingRelationship {
  final String positionId;
  final String positionCode;
  final String titleEnglish;
  final String titleArabic;
  final String status;
  final SimplePosition? reportsTo;
  final List<ReportingRelationship> directReports;

  // Additional fields needed for the table view (if not provided by this specific API,
  // they might need to be filled from elsewhere or kept empty)
  final String? department;
  final String? level;
  final String? gradeStep;

  const ReportingRelationship({
    required this.positionId,
    required this.positionCode,
    required this.titleEnglish,
    required this.titleArabic,
    required this.status,
    this.reportsTo,
    this.directReports = const [],
    this.department,
    this.level,
    this.gradeStep,
  });

  /// Utility to convert to a flat ReportingPosition entity used by the table
  ReportingPosition toReportingPosition() {
    return ReportingPosition(
      positionId: positionId,
      positionCode: positionCode,
      titleEnglish: titleEnglish,
      titleArabic: titleArabic,
      department: department ?? '-',
      level: level ?? '-',
      gradeStep: gradeStep ?? '-',
      reportsToTitle: reportsTo?.titleEnglish,
      reportsToCode: reportsTo?.code,
      directReportsCount: directReports.length,
      status: status.toLowerCase(),
    );
  }
}
