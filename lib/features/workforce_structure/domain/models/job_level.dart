import 'grade.dart';

/// Job Level domain model (Entity)
class JobLevel {
  final int id;
  final String nameEn;
  final String code;
  final String description;
  final int minGradeId;
  final int maxGradeId;
  final String status;
  final Grade? minGrade;
  final Grade? maxGrade;
  final int totalPositions;
  final int filledPositions;

  const JobLevel({
    required this.id,
    required this.nameEn,
    required this.code,
    required this.description,
    required this.minGradeId,
    required this.maxGradeId,
    required this.status,
    this.minGrade,
    this.maxGrade,
    this.totalPositions = 0,
    this.filledPositions = 0,
  });

  bool get isActive => status == 'ACTIVE';

  double get fillRate =>
      totalPositions > 0 ? (filledPositions / totalPositions) * 100 : 0.0;

  String get gradeRange {
    if (minGrade != null && maxGrade != null) {
      final minPrefix = minGrade!.gradeNumber.toLowerCase().contains('grade')
          ? ''
          : 'Grade ';
      final maxPrefix = maxGrade!.gradeNumber.toLowerCase().contains('grade')
          ? ''
          : 'Grade ';
      return '$minPrefix${minGrade!.gradeNumber} - $maxPrefix${maxGrade!.gradeNumber}';
    }
    return '-';
  }

  JobLevel copyWith({
    int? id,
    String? nameEn,
    String? code,
    String? description,
    int? minGradeId,
    int? maxGradeId,
    String? status,
    Grade? minGrade,
    Grade? maxGrade,
    int? totalPositions,
    int? filledPositions,
  }) {
    return JobLevel(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
      description: description ?? this.description,
      minGradeId: minGradeId ?? this.minGradeId,
      maxGradeId: maxGradeId ?? this.maxGradeId,
      status: status ?? this.status,
      minGrade: minGrade ?? this.minGrade,
      maxGrade: maxGrade ?? this.maxGrade,
      totalPositions: totalPositions ?? this.totalPositions,
      filledPositions: filledPositions ?? this.filledPositions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobLevel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
