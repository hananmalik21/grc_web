import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class ApproveRequisitionUseCase {
  const ApproveRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.approveRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
