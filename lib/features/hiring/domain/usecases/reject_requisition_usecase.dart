import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class RejectRequisitionUseCase {
  const RejectRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({
    required String requisitionGuid,
    required int enterpriseId,
    required String rejectionReason,
  }) {
    return repository.rejectRequisition(
      requisitionGuid: requisitionGuid,
      enterpriseId: enterpriseId,
      rejectionReason: rejectionReason,
    );
  }
}
