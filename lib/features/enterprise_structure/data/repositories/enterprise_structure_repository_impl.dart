import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/enterprise_structure_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/dto/save_enterprise_structure_dto.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_structure_repository.dart';

class EnterpriseStructureRepositoryImpl implements EnterpriseStructureRepository {
  final EnterpriseStructureRemoteDataSource remoteDataSource;

  EnterpriseStructureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<EnterpriseStructure> saveEnterpriseStructure(EnterpriseStructure structure) async {
    try {
      final requestDto = SaveEnterpriseStructureRequestDto(
        enterpriseId: structure.enterpriseId,
        structureCode: structure.structureCode,
        structureName: structure.structureName,
        structureType: structure.structureType,
        description: structure.description,
        isActive: structure.isActive,
        levels: structure.levels
            .map(
              (level) => StructureLevelDto(
                structureLevelId: level.structureLevelId,
                levelNumber: level.levelNumber,
                displayOrder: level.displayOrder,
              ),
            )
            .toList(),
      );

      await remoteDataSource.saveEnterpriseStructure(requestDto);
      return structure;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<EnterpriseStructure> updateEnterpriseStructure(String structureId, EnterpriseStructure structure) async {
    try {
      final requestDto = SaveEnterpriseStructureRequestDto(
        enterpriseId: structure.enterpriseId,
        structureCode: structure.structureCode,
        structureName: structure.structureName,
        structureType: structure.structureType,
        description: structure.description,
        isActive: structure.isActive,
        levels: structure.levels
            .map(
              (level) => StructureLevelDto(
                structureLevelId: level.structureLevelId,
                levelNumber: level.levelNumber,
                displayOrder: level.displayOrder,
              ),
            )
            .toList(),
      );

      await remoteDataSource.updateEnterpriseStructure(structureId, requestDto);
      return structure;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
