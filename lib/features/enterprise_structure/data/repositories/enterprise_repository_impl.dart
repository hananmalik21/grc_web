import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/enterprise_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_repository.dart';

/// Implementation of EnterpriseRepository
class EnterpriseRepositoryImpl implements EnterpriseRepository {
  final EnterpriseRemoteDataSource remoteDataSource;

  EnterpriseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Enterprise>> getEnterprises() async {
    try {
      final dtos = await remoteDataSource.getEnterprises();
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

