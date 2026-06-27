/// ReportingPosition domain model
/// Represents a position in the reporting structure
class ReportingPosition {
  final String positionId;
  final String positionCode;
  final String titleEnglish;
  final String titleArabic;
  final String department;
  final String level;
  final String gradeStep;
  final String? reportsToTitle;
  final String? reportsToCode;
  final int directReportsCount;
  final String status;

  const ReportingPosition({
    required this.positionId,
    required this.positionCode,
    required this.titleEnglish,
    required this.titleArabic,
    required this.department,
    required this.level,
    required this.gradeStep,
    this.reportsToTitle,
    this.reportsToCode,
    required this.directReportsCount,
    required this.status,
  });

  bool get isTopLevel => reportsToTitle == null;
  bool get hasDirectReports => directReportsCount > 0;

  ReportingPosition copyWith({
    String? positionId,
    String? positionCode,
    String? titleEnglish,
    String? titleArabic,
    String? department,
    String? level,
    String? gradeStep,
    String? reportsToTitle,
    String? reportsToCode,
    int? directReportsCount,
    String? status,
  }) {
    return ReportingPosition(
      positionId: positionId ?? this.positionId,
      positionCode: positionCode ?? this.positionCode,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      titleArabic: titleArabic ?? this.titleArabic,
      department: department ?? this.department,
      level: level ?? this.level,
      gradeStep: gradeStep ?? this.gradeStep,
      reportsToTitle: reportsToTitle ?? this.reportsToTitle,
      reportsToCode: reportsToCode ?? this.reportsToCode,
      directReportsCount: directReportsCount ?? this.directReportsCount,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportingPosition && other.positionCode == positionCode;
  }

  @override
  int get hashCode => positionCode.hashCode;

  @override
  String toString() {
    return 'ReportingPosition(positionCode: $positionCode, titleEnglish: $titleEnglish)';
  }
}
