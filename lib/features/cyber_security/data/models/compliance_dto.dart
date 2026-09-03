class ComplianceFrameworkDto {
  final String id;
  final String code;
  final String name;
  final String? currentVersionId;

  const ComplianceFrameworkDto({
    required this.id,
    required this.code,
    required this.name,
    this.currentVersionId,
  });

  factory ComplianceFrameworkDto.fromJson(Map<String, dynamic> json) =>
      ComplianceFrameworkDto(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        currentVersionId:
            json['currentVersionId']?.toString() ??
            json['current_version_id']?.toString(),
      );
}

class ComplianceAssessmentDto {
  final String id;
  final String frameworkVersionId;
  final String name;
  final String status;
  final double? overallScore;

  const ComplianceAssessmentDto({
    required this.id,
    required this.frameworkVersionId,
    required this.name,
    required this.status,
    this.overallScore,
  });

  factory ComplianceAssessmentDto.fromJson(Map<String, dynamic> json) =>
      ComplianceAssessmentDto(
        id: json['id']?.toString() ?? '',
        frameworkVersionId:
            json['frameworkVersionId']?.toString() ??
            json['framework_version_id']?.toString() ??
            '',
        name: json['name']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        overallScore:
            (json['overallScore'] as num?)?.toDouble() ??
            (json['overall_score'] as num?)?.toDouble(),
      );
}

class FrameworkComplianceItem {
  final String code;
  final String name;
  final double score;

  const FrameworkComplianceItem({
    required this.code,
    required this.name,
    required this.score,
  });
}
