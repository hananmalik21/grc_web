import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';

class GradeRecordResponseDto {
  final bool success;
  final String? message;
  final List<GradeRecordDto> data;

  const GradeRecordResponseDto({
    required this.success,
    this.message,
    required this.data,
  });

  factory GradeRecordResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return GradeRecordResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: dataList
          .map((e) => GradeRecordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<GradeRecord> toDomain() => data.map((d) => d.toDomain()).toList();
}

class GradeRecordDto {
  final String? gradeLevel;
  final String? description;
  final String? minSalary;
  final String? maxSalary;
  final String? increment;
  final String? steps;
  final String? status;

  const GradeRecordDto({
    this.gradeLevel,
    this.description,
    this.minSalary,
    this.maxSalary,
    this.increment,
    this.steps,
    this.status,
  });

  factory GradeRecordDto.fromJson(Map<String, dynamic> json) {
    return GradeRecordDto(
      gradeLevel: json['grade_level'] as String?,
      description: json['description'] as String?,
      minSalary: json['min_salary']?.toString(),
      maxSalary: json['max_salary']?.toString(),
      increment: json['increment']?.toString(),
      steps: json['steps']?.toString(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_level': gradeLevel,
      'description': description,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'increment': increment,
      'steps': steps,
      'status': status,
    };
  }

  GradeRecord toDomain() {
    return GradeRecord(
      gradeLevel: gradeLevel,
      description: description,
      minSalary: minSalary,
      maxSalary: maxSalary,
      increment: increment,
      steps: steps,
      status: status,
    );
  }

  factory GradeRecordDto.fromDomain(GradeRecord domain) {
    return GradeRecordDto(
      gradeLevel: domain.gradeLevel,
      description: domain.description,
      minSalary: domain.minSalary,
      maxSalary: domain.maxSalary,
      increment: domain.increment,
      steps: domain.steps,
      status: domain.status,
    );
  }
}
