import 'package:grc/features/hiring/domain/models/applications/reject_application_input.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class RejectApplicationUseCase {
  const RejectApplicationUseCase({required this.repository});

  final ApplicationsRepository repository;

  Future<Map<String, dynamic>> call(RejectApplicationInput input) {
    return repository.rejectApplication(input);
  }
}
