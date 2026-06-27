import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/repositories/grade_repository.dart';

class UpdateGradeUseCase {
  final GradeRepository repository;

  UpdateGradeUseCase(this.repository);

  Future<Grade> execute(int gradeId, Grade grade, {int? tenantId}) {
    return repository.updateGrade(gradeId, grade, tenantId: tenantId);
  }
}
