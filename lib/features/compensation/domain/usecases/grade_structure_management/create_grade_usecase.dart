import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';
import 'package:grc/features/compensation/domain/repositories/grade_structure_management/grade_structure_repository.dart';

class CreateGradeUseCase {
  final GradeStructureRepository repository;

  const CreateGradeUseCase({required this.repository});

  Future<void> call(GradeRecord grade) {
    return repository.createGrade(grade);
  }
}
