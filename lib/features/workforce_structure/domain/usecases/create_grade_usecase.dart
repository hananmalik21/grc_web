import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/repositories/grade_repository.dart';

class CreateGradeUseCase {
  final GradeRepository repository;

  CreateGradeUseCase(this.repository);

  Future<Grade> execute(Grade grade, {int? tenantId}) {
    return repository.createGrade(grade, tenantId: tenantId);
  }
}
