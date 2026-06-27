import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_structure_repository.dart';

class SaveEnterpriseStructureUseCase {
  final EnterpriseStructureRepository repository;

  SaveEnterpriseStructureUseCase({required this.repository});

  Future<EnterpriseStructure> call(EnterpriseStructure structure) async {
    try {
      if (structure.structureName.isEmpty) {
        throw ValidationException('Structure name is required');
      }
      if (structure.structureCode.isEmpty) {
        throw ValidationException('Structure code is required');
      }
      if (structure.levels.isEmpty) {
        throw ValidationException('At least one level is required');
      }

      return await repository.saveEnterpriseStructure(structure);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to save enterprise structure: ${e.toString()}', originalError: e);
    }
  }

  Future<EnterpriseStructure> updateStructure(String structureId, EnterpriseStructure structure) async {
    try {
      if (structure.structureName.isEmpty) {
        throw ValidationException('Structure name is required');
      }
      if (structure.structureCode.isEmpty) {
        throw ValidationException('Structure code is required');
      }

      return await repository.updateEnterpriseStructure(structureId, structure);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update enterprise structure: ${e.toString()}', originalError: e);
    }
  }
}
