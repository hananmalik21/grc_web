import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class DeleteRequisitionUseCase {
  const DeleteRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.deleteRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
