import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';
import 'package:grc/features/hiring/data/dto/requisition_full_dto.dart';

class GetRequisitionByGuidUseCase {
  const GetRequisitionByGuidUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<RequisitionFullDto> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.getRequisitionByGuid(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
