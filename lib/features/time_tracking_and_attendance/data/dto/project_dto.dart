import 'package:grc/features/time_tracking_and_attendance/domain/models/project.dart';

class ProjectDto {
  final int projectId;
  final String projectGuid;
  final int enterpriseId;
  final String projectCode;
  final String projectName;
  final String projectStatus;

  const ProjectDto({
    required this.projectId,
    required this.projectGuid,
    required this.enterpriseId,
    required this.projectCode,
    required this.projectName,
    required this.projectStatus,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      projectId: (json['project_id'] as num?)?.toInt() ?? 0,
      projectGuid: json['project_guid'] as String? ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      projectCode: json['project_code'] as String? ?? '',
      projectName: json['project_name'] as String? ?? '',
      projectStatus: json['project_status'] as String? ?? '',
    );
  }

  Project toDomain() {
    return Project(
      id: projectId,
      guid: projectGuid,
      enterpriseId: enterpriseId,
      code: projectCode,
      name: projectName,
      status: projectStatus,
    );
  }
}
