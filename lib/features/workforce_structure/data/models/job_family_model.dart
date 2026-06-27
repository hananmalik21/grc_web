import 'package:grc/features/workforce_structure/domain/models/job_family.dart';

/// Job Family Data Model (Data Layer)
/// Handles serialization/deserialization for API communication
class JobFamilyModel {
  final int id;
  final String code;
  final String nameEnglish;
  final String nameArabic;
  final String description;
  final int totalPositions;
  final int filledPositions;
  final double fillRate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JobFamilyModel({
    required this.id,
    required this.code,
    required this.nameEnglish,
    required this.nameArabic,
    required this.description,
    required this.totalPositions,
    required this.filledPositions,
    required this.fillRate,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from API JSON response
  factory JobFamilyModel.fromJson(Map<String, dynamic> json) {
    return JobFamilyModel(
      id: json['job_family_id'] as int? ?? json['id'] as int? ?? 0,
      code: json['job_family_code'] as String? ?? json['code'] as String? ?? '',
      nameEnglish: json['job_family_name_en'] as String? ?? '',
      nameArabic: json['job_family_name_ar'] as String? ?? '',
      description: json['description'] as String? ?? '',
      totalPositions: json['total_positions'] as int? ?? 0,
      filledPositions: json['filled_positions'] as int? ?? 0,
      fillRate: (json['fill_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'job_family_code': code,
      'job_family_name_en': nameEnglish,
      'job_family_name_ar': nameArabic,
      'description': description,
      'total_positions': totalPositions,
      'filled_positions': filledPositions,
      'fill_rate': fillRate,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Convert data model to domain entity
  JobFamily toEntity() {
    return JobFamily(
      id: id,
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      totalPositions: totalPositions,
      filledPositions: filledPositions,
      fillRate: fillRate,
      isActive: status == 'ACTIVE',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create data model from domain entity
  factory JobFamilyModel.fromEntity(JobFamily entity) {
    return JobFamilyModel(
      id: entity.id,
      code: entity.code,
      nameEnglish: entity.nameEnglish,
      nameArabic: entity.nameArabic,
      description: entity.description,
      totalPositions: entity.totalPositions,
      filledPositions: entity.filledPositions,
      fillRate: entity.fillRate,
      status: entity.isActive ? 'ACTIVE' : 'INACTIVE',
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
