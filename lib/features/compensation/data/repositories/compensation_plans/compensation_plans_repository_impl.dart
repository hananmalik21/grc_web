import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';
import 'package:grc/features/compensation/data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plans_page.dart';
import 'package:grc/features/compensation/domain/models/employee_compensation/create_employee_compensation_request.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class CompensationPlansRepositoryImpl implements CompensationPlansRepository {
  final CompensationPlansRemoteDataSource remoteDataSource;

  CompensationPlansRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompensationPlansPage> getCompensationPlans({
    required int enterpriseId,
    required int page,
    required int limit,
    String? search,
    String? planTypeCode,
    String? currencyCode,
    String? statusCode,
  }) async {
    try {
      final dto = await remoteDataSource.getCompensationPlans(
        enterpriseId: enterpriseId,
        page: page,
        limit: limit,
        search: search,
        planTypeCode: planTypeCode,
        currencyCode: currencyCode,
        statusCode: statusCode,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch compensation plans: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompensationPlan> getCompensationPlanDetail({required String planGuid}) async {
    try {
      final dto = await remoteDataSource.getCompensationPlanDetail(planGuid: planGuid);
      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CompensationPlan>> getEligiblePlansForEmployee({required String employeeGuid}) async {
    try {
      final dtos = await remoteDataSource.getEligiblePlansForEmployee(employeeGuid: employeeGuid);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompensationPlan>> getEligiblePlansByCriteria({required EligiblePlansCriteria criteria}) async {
    try {
      final dtos = await remoteDataSource.getEligiblePlansByCriteria(criteria: criteria);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans by criteria: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompensationPlan>> getEligiblePlansByPosition({
    required String positionId,
    required int enterpriseId,
  }) async {
    try {
      final dtos = await remoteDataSource.getEligiblePlansByPosition(
        positionId: positionId,
        enterpriseId: enterpriseId,
      );
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans by position: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createCompensationPlan({required CreateCompensationPlanRequestDto request}) async {
    try {
      await remoteDataSource.createCompensationPlan(request: request);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create compensation plan: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createEmployeeCompensation({required CreateEmployeeCompensationRequest request}) async {
    try {
      await remoteDataSource.createEmployeeCompensation(request: request.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create employee compensation: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateCompensationPlan({
    required String planGuid,
    required CreateCompensationPlanRequestDto request,
  }) async {
    try {
      await remoteDataSource.updateCompensationPlan(planGuid: planGuid, request: request);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update compensation plan: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteCompensationPlan({required String planGuid}) async {
    try {
      await remoteDataSource.deleteCompensationPlan(planGuid: planGuid);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete compensation plan: ${e.toString()}', originalError: e);
    }
  }
}
