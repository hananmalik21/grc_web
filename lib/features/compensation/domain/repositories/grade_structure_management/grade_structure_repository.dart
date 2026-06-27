import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';

abstract class GradeStructureRepository {
  Future<List<GradeRecord>> getGrades();
  Future<void> createGrade(GradeRecord grade);
  Future<void> updateGrade(GradeRecord grade);
  Future<void> deleteGrade(String gradeLevel);
}
