import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';

class GetSalaryStructuresUseCase {
  final SalaryStructureRepository repository;

  const GetSalaryStructuresUseCase({required this.repository});

  Future<SalaryStructurePage> call({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? status,
  }) {
    return repository.getSalaryStructures(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
    );
  }
}
