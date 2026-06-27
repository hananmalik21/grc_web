import 'package:grc/features/hiring/data/dto/create_requisition_request_dto.dart';
import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';

class CreateRequisitionUseCase {
  const CreateRequisitionUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<Map<String, dynamic>> call(CreateRequisitionRequestDto request) {
    return repository.createRequisition(request);
  }
}
