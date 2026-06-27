import 'package:grc/core/utils/int_parse_utils.dart';
import 'package:grc/features/workforce_structure/data/models/grade_model.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';

class JobLevelModel {
  final int id;
  final String nameEn;
  final String code;
  final String description;
  final int minGradeId;
  final int maxGradeId;
  final String status;
  final GradeModel? minGrade;
  final GradeModel? maxGrade;
  final int totalPositions;
  final int filledPositions;

  const JobLevelModel({
    required this.id,
    required this.nameEn,
    required this.code,
    required this.description,
    required this.minGradeId,
    required this.maxGradeId,
    required this.status,
    this.minGrade,
    this.maxGrade,
    required this.totalPositions,
    required this.filledPositions,
  });

  factory JobLevelModel.fromJson(Map<String, dynamic> json) {
    return JobLevelModel(
      id: json['job_level_id'] as int? ?? 0,
      nameEn: json['level_name_en'] as String? ?? '',
      code: json['level_code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      minGradeId: json['min_grade_id'] as int? ?? 0,
      maxGradeId: json['max_grade_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
      minGrade: json['min_grade'] != null ? GradeModel.fromJson(json['min_grade'] as Map<String, dynamic>) : null,
      maxGrade: json['max_grade'] != null ? GradeModel.fromJson(json['max_grade'] as Map<String, dynamic>) : null,
      totalPositions:
          IntParseUtils.tryParse(json['position_count']) ?? IntParseUtils.tryParse(json['total_positions']) ?? 0,
      filledPositions: IntParseUtils.asInt(json['filled_positions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_level_id': id,
      'level_name_en': nameEn,
      'level_code': code,
      'description': description,
      'min_grade_id': minGradeId,
      'max_grade_id': maxGradeId,
      'status': status,
      if (minGrade != null) 'min_grade': minGrade!.toJson(),
      if (maxGrade != null) 'max_grade': maxGrade!.toJson(),
      'total_positions': totalPositions,
      'filled_positions': filledPositions,
    };
  }

  JobLevel toEntity() {
    return JobLevel(
      id: id,
      nameEn: nameEn,
      code: code,
      description: description,
      minGradeId: minGradeId,
      maxGradeId: maxGradeId,
      status: status,
      minGrade: minGrade?.toEntity(),
      maxGrade: maxGrade?.toEntity(),
      totalPositions: totalPositions,
      filledPositions: filledPositions,
    );
  }

  factory JobLevelModel.fromEntity(JobLevel entity) {
    return JobLevelModel(
      id: entity.id,
      nameEn: entity.nameEn,
      code: entity.code,
      description: entity.description,
      minGradeId: entity.minGradeId,
      maxGradeId: entity.maxGradeId,
      status: entity.status,
      minGrade: entity.minGrade != null ? GradeModel.fromEntity(entity.minGrade!) : null,
      maxGrade: entity.maxGrade != null ? GradeModel.fromEntity(entity.maxGrade!) : null,
      totalPositions: entity.totalPositions,
      filledPositions: entity.filledPositions,
    );
  }
}
