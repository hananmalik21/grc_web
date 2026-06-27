import 'package:grc/features/compensation/data/dto/salary_structure_management/create_salary_structure_request_dto.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_full_details.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';

abstract class SalaryStructureRepository {
  Future<void> createSalaryStructure(CreateSalaryStructureRequestDto request);
  Future<void> updateSalaryStructure({required String structureGuid, required CreateSalaryStructureRequestDto request});
  Future<void> deleteSalaryStructure({required String structureGuid});
  Future<SalaryStructurePage> getSalaryStructures({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? status,
  });
  Future<SalaryStructureDetails> getSalaryStructureDetails({required int enterpriseId, required String structureGuid});
  Future<SalaryStructureFullDetails> getSalaryStructureFullDetails({
    required int enterpriseId,
    required String structureGuid,
  });
}
