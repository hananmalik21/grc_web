import 'package:grc/features/hiring/data/datasources/requisitions_remote_data_source.dart';
import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';
import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class RequisitionsRepositoryImpl implements RequisitionsRepository {
  const RequisitionsRepositoryImpl({required this.remoteDataSource});

  final RequisitionsRemoteDataSource remoteDataSource;

  @override
  Future<RequisitionsPageDto> getRequisitions({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    final dto = await remoteDataSource.getRequisitions(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    return dto;
  }

  @override
  Future<RequisitionFullDto> getRequisitionByGuid({required String requisitionGuid, required int enterpriseId}) async {
    final dto = await remoteDataSource.getRequisitionByGuid(
      requisitionGuid: requisitionGuid,
      enterpriseId: enterpriseId,
    );
    return dto;
  }

  @override
  Future<Map<String, dynamic>> createRequisition(CreateRequisitionRequestDto request) {
    return remoteDataSource.createRequisition(request);
  }

  @override
  Future<Map<String, dynamic>> updateRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required CreateRequisitionRequestDto request,
  }) {
    return remoteDataSource.updateRequisition(
      requisitionGuid: requisitionGuid,
      enterpriseId: enterpriseId,
      request: request,
    );
  }

  @override
  Future<Map<String, dynamic>> approveRequisition({required String requisitionGuid, required int enterpriseId}) {
    return remoteDataSource.approveRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<Map<String, dynamic>> rejectRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required String rejectionReason,
  }) {
    return remoteDataSource.rejectRequisition(
      requisitionGuid: requisitionGuid,
      enterpriseId: enterpriseId,
      rejectionReason: rejectionReason,
    );
  }

  @override
  Future<Map<String, dynamic>> deleteRequisition({required String requisitionGuid, required int enterpriseId}) {
    return remoteDataSource.deleteRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<Map<String, dynamic>> reopenRequisition({required String requisitionGuid, required int enterpriseId}) {
    return remoteDataSource.reopenRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<Map<String, dynamic>> closeRequisition({required String requisitionGuid, required int enterpriseId}) {
    return remoteDataSource.closeRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<Map<String, dynamic>> holdRequisition({required String requisitionGuid, required int enterpriseId}) {
    return remoteDataSource.holdRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
