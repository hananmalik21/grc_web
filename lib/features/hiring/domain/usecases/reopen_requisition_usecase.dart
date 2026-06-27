import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class ReopenRequisitionUseCase {
  const ReopenRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.reopenRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
