import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';

/// Grade response with pagination
class GradeResponse {
  final List<Grade> data;
  final JobLevelMeta meta;

  const GradeResponse({required this.data, required this.meta});
}
