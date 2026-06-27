import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/create_salary_structure_request_dto.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_full_details.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';

class SalaryStructureRepositoryImpl implements SalaryStructureRepository {
  final SalaryStructureRemoteDataSource remoteDataSource;

  SalaryStructureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createSalaryStructure(CreateSalaryStructureRequestDto request) {
    return remoteDataSource.createSalaryStructure(request);
  }

  @override
  Future<void> updateSalaryStructure({
    required String structureGuid,
    required CreateSalaryStructureRequestDto request,
  }) {
    return remoteDataSource.updateSalaryStructure(structureGuid: structureGuid, request: request);
  }

  @override
  Future<void> deleteSalaryStructure({required String structureGuid}) {
    return remoteDataSource.deleteSalaryStructure(structureGuid: structureGuid);
  }

  @override
  Future<SalaryStructurePage> getSalaryStructures({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? status,
  }) async {
    try {
      final dto = await remoteDataSource.getSalaryStructures(
        enterpriseId: enterpriseId,
        page: page,
        pageSize: pageSize,
        search: search,
        status: status,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structures: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<SalaryStructureDetails> getSalaryStructureDetails({
    required int enterpriseId,
    required String structureGuid,
  }) async {
    try {
      final dto = await remoteDataSource.getSalaryStructureDetails(
        enterpriseId: enterpriseId,
        structureGuid: structureGuid,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structure details: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<SalaryStructureFullDetails> getSalaryStructureFullDetails({
    required int enterpriseId,
    required String structureGuid,
  }) async {
    try {
      final dto = await remoteDataSource.getSalaryStructureFullDetails(
        enterpriseId: enterpriseId,
        structureGuid: structureGuid,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structure details: ${e.toString()}', originalError: e);
    }
  }
}
