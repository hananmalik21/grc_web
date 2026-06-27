import 'package:grc/features/workforce_structure/domain/models/grade.dart';

/// Grade data model (DTO)
class GradeModel {
  final int gradeId;
  final String gradeNumber;
  final String? gradeNumberMeaningEn;
  final String? gradeNumberMeaningAr;
  final String gradeCategory;
  final String? gradeCategoryMeaningEn;
  final String? gradeCategoryMeaningAr;
  final String currencyCode;
  final double step1Salary;
  final double step2Salary;
  final double step3Salary;
  final double step4Salary;
  final double step5Salary;
  final String description;
  final String status;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String lastUpdateLogin;

  const GradeModel({
    required this.gradeId,
    required this.gradeNumber,
    this.gradeNumberMeaningEn,
    this.gradeNumberMeaningAr,
    required this.gradeCategory,
    this.gradeCategoryMeaningEn,
    this.gradeCategoryMeaningAr,
    required this.currencyCode,
    required this.step1Salary,
    required this.step2Salary,
    required this.step3Salary,
    required this.step4Salary,
    required this.step5Salary,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.lastUpdateLogin,
  });

  // ---------- Safe parsers ----------
  static String _asString(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    if (v is String) return v;
    return v.toString();
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static double _asDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  static String? _optionalString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v.trim().isEmpty ? null : v;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    final gradeNumberObj = json['grade_number_obj'];
    final gradeCategoryObj = json['grade_category_obj'];
    final numberObj = gradeNumberObj is Map<String, dynamic> ? gradeNumberObj : null;
    final categoryObj = gradeCategoryObj is Map<String, dynamic> ? gradeCategoryObj : null;

    return GradeModel(
      gradeId: _asInt(json['grade_id']),
      gradeNumber: _asString(json['grade_number']),
      gradeNumberMeaningEn: _optionalString(numberObj?['meaning_en']),
      gradeNumberMeaningAr: _optionalString(numberObj?['meaning_ar']),
      gradeCategory: _asString(json['grade_category']),
      gradeCategoryMeaningEn: _optionalString(categoryObj?['meaning_en']),
      gradeCategoryMeaningAr: _optionalString(categoryObj?['meaning_ar']),
      currencyCode: _asString(json['currency_code']),
      step1Salary: _asDouble(json['step_1_salary']),
      step2Salary: _asDouble(json['step_2_salary']),
      step3Salary: _asDouble(json['step_3_salary']),
      step4Salary: _asDouble(json['step_4_salary']),
      step5Salary: _asDouble(json['step_5_salary']),
      description: _optionalString(json['description']) ?? '',
      status: _asString(json['status'], fallback: 'ACTIVE'),
      createdBy: _asString(json['created_by'], fallback: 'SYSTEM'),
      createdDate: _asString(json['created_date']),
      lastUpdatedBy: _asString(json['last_updated_by'], fallback: 'SYSTEM'),
      lastUpdatedDate: _asString(json['last_updated_date']),
      lastUpdateLogin: _asString(json['last_update_login'], fallback: 'SYSTEM'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_id': gradeId,
      'grade_number': gradeNumber,
      'grade_category': gradeCategory,
      'currency_code': currencyCode,
      'step_1_salary': step1Salary,
      'step_2_salary': step2Salary,
      'step_3_salary': step3Salary,
      'step_4_salary': step4Salary,
      'step_5_salary': step5Salary,
      'description': description,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'last_updated_by': lastUpdatedBy,
      'last_updated_date': lastUpdatedDate,
      'last_update_login': lastUpdateLogin,
    };
  }

  // safer DateTime parsing (prevents crash if backend sends null/empty)
  static DateTime _parseDate(String v) {
    if (v.trim().isEmpty) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  Grade toEntity() {
    return Grade(
      id: gradeId,
      gradeNumber: gradeNumber,
      gradeNumberMeaningEn: gradeNumberMeaningEn,
      gradeNumberMeaningAr: gradeNumberMeaningAr,
      gradeCategory: gradeCategory,
      gradeCategoryMeaningEn: gradeCategoryMeaningEn,
      gradeCategoryMeaningAr: gradeCategoryMeaningAr,
      currencyCode: currencyCode,
      step1Salary: step1Salary,
      step2Salary: step2Salary,
      step3Salary: step3Salary,
      step4Salary: step4Salary,
      step5Salary: step5Salary,
      description: description,
      status: status,
      createdBy: createdBy,
      createdDate: _parseDate(createdDate),
      lastUpdatedBy: lastUpdatedBy,
      lastUpdatedDate: _parseDate(lastUpdatedDate),
      lastUpdateLogin: lastUpdateLogin,
    );
  }

  factory GradeModel.fromEntity(Grade entity) {
    return GradeModel(
      gradeId: entity.id,
      gradeNumber: entity.gradeNumber,
      gradeNumberMeaningEn: entity.gradeNumberMeaningEn,
      gradeNumberMeaningAr: entity.gradeNumberMeaningAr,
      gradeCategory: entity.gradeCategory,
      gradeCategoryMeaningEn: entity.gradeCategoryMeaningEn,
      gradeCategoryMeaningAr: entity.gradeCategoryMeaningAr,
      currencyCode: entity.currencyCode,
      step1Salary: entity.step1Salary,
      step2Salary: entity.step2Salary,
      step3Salary: entity.step3Salary,
      step4Salary: entity.step4Salary,
      step5Salary: entity.step5Salary,
      description: entity.description,
      status: entity.status,
      createdBy: entity.createdBy,
      createdDate: entity.createdDate.toIso8601String(),
      lastUpdatedBy: entity.lastUpdatedBy,
      lastUpdatedDate: entity.lastUpdatedDate.toIso8601String(),
      lastUpdateLogin: entity.lastUpdateLogin,
    );
  }
}
