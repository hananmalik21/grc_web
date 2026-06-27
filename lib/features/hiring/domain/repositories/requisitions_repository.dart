import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';

abstract class RequisitionsRepository {
  Future<RequisitionsPageDto> getRequisitions({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<RequisitionFullDto> getRequisitionByGuid({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> createRequisition(CreateRequisitionRequestDto request);

  Future<Map<String, dynamic>> updateRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required CreateRequisitionRequestDto request,
  });

  Future<Map<String, dynamic>> approveRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> rejectRequisition({
    required String requisitionGuid,
    required int enterpriseId,
    required String rejectionReason,
  });

  Future<Map<String, dynamic>> deleteRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> reopenRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> closeRequisition({required String requisitionGuid, required int enterpriseId});

  Future<Map<String, dynamic>> holdRequisition({required String requisitionGuid, required int enterpriseId});
}
