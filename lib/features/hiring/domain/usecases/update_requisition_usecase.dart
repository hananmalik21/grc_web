import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class UpdateRequisitionUseCase {
  const UpdateRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({
    required String requisitionGuid,
    required int enterpriseId,
    required CreateRequisitionRequestDto request,
  }) {
    return repository.updateRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId, request: request);
  }
}
