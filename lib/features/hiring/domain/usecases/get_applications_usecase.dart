import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class GetApplicationsUseCase {
  const GetApplicationsUseCase({required this.repository});

  final ApplicationsRepository repository;

  Future<ApplicationsPage> call({required int enterpriseId, int page = 1, int limit = 10}) {
    return repository.getApplications(enterpriseId: enterpriseId, page: page, limit: limit);
  }
}
