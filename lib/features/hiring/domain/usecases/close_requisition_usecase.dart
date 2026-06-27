import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class CloseRequisitionUseCase {
  const CloseRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call({required String requisitionGuid, required int enterpriseId}) {
    return repository.closeRequisition(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId);
  }
}
