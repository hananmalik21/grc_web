import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/structure_level_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/structure_level_repository.dart';

/// Implementation of StructureLevelRepository
/// Maps data layer to domain layer
class StructureLevelRepositoryImpl implements StructureLevelRepository {
  final StructureLevelRemoteDataSource remoteDataSource;

  StructureLevelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<StructureLevel>> getStructureLevels() async {
    try {
      final dtos = await remoteDataSource.getStructureLevels();
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

