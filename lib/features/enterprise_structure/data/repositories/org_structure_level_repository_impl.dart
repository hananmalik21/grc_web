import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/org_structure_level_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_structure_level_repository.dart';

class OrgStructureLevelRepositoryImpl implements OrgStructureLevelRepository {
  final OrgStructureLevelRemoteDataSource remoteDataSource;

  OrgStructureLevelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ActiveStructureLevel>> getActiveLevels({int? enterpriseId}) async {
    try {
      final responseDto = await remoteDataSource.getActiveLevels(enterpriseId: enterpriseId);
      final activeLevels = responseDto.levels
          .where((dto) => dto.isActive.toUpperCase() == 'Y')
          .map((dto) => dto.toDomain())
          .toList();
      activeLevels.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return activeLevels;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
