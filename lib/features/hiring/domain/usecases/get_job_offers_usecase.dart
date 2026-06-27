import 'package:grc/features/hiring/data/dto/job_offers_dto.dart';
import 'package:grc/features/hiring/domain/repositories/job_offers_repository.dart';

class GetJobOffersUseCase {
  const GetJobOffersUseCase({required this.repository});

  final JobOffersRepository repository;

  Future<JobOffersPageDto> call({required int enterpriseId, int page = 1, int limit = 10, String? status}) {
    return repository.getJobOffers(enterpriseId: enterpriseId, page: page, limit: limit, status: status);
  }
}
