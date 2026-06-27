import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class HoldRequisitionUseCase {
  const HoldRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.holdRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
