import 'package:grc/features/hiring/domain/models/applications/application_detail.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class GetApplicationDetailUseCase {
  const GetApplicationDetailUseCase({required this.repository});

  final ApplicationsRepository repository;

  Future<ApplicationDetail> call({required String applicationGuid, required int enterpriseId}) {
    return repository.getApplicationByGuid(applicationGuid: applicationGuid, enterpriseId: enterpriseId);
  }
}
