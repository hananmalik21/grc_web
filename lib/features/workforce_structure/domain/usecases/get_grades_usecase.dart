import 'package:grc/features/workforce_structure/domain/models/grade_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/grade_repository.dart';

class GetGradesUseCase {
  final GradeRepository repository;

  GetGradesUseCase(this.repository);

  Future<GradeResponse> execute({int page = 1, int pageSize = 10, String? search, int? tenantId}) {
    return repository.getGrades(page: page, pageSize: pageSize, search: search, tenantId: tenantId);
  }
}
