import 'package:grc/features/compensation/domain/repositories/grade_structure_management/grade_structure_repository.dart';

class DeleteGradeUseCase {
  final GradeStructureRepository repository;

  const DeleteGradeUseCase({required this.repository});

  Future<void> call(String gradeLevel) {
    return repository.deleteGrade(gradeLevel);
  }
}
