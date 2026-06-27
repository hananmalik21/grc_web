import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_response.dart';

abstract class GradeRepository {
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10, String? search, int? tenantId});
  Future<Grade> createGrade(Grade grade, {int? tenantId});
  Future<Grade> updateGrade(int gradeId, Grade grade, {int? tenantId});
  Future<void> deleteGrade(int gradeId, {int? tenantId});
}
