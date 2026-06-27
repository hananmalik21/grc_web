import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';
import 'package:grc/features/compensation/domain/repositories/grade_structure_management/grade_structure_repository.dart';

class GetGradesUseCase {
  final GradeStructureRepository repository;

  const GetGradesUseCase({required this.repository});

  Future<List<GradeRecord>> call() {
    return repository.getGrades();
  }
}
