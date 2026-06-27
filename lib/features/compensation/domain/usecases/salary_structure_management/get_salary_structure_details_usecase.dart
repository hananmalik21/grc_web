import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';

class GetSalaryStructureDetailsUseCase {
  final SalaryStructureRepository repository;

  GetSalaryStructureDetailsUseCase({required this.repository});

  Future<SalaryStructureDetails> call({required int enterpriseId, required String structureGuid}) {
    return repository.getSalaryStructureDetails(enterpriseId: enterpriseId, structureGuid: structureGuid);
  }
}
