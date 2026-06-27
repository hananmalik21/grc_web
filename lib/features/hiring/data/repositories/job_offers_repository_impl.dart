import 'package:grc/features/hiring/data/datasources/job_offers_remote_data_source.dart';
import 'package:grc/features/hiring/data/dto/job_offers_dto.dart';
import 'package:grc/features/hiring/domain/models/job_offers/create_job_offer_input.dart';
import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';
import 'package:grc/features/hiring/domain/repositories/job_offers_repository.dart';

class JobOffersRepositoryImpl implements JobOffersRepository {
  const JobOffersRepositoryImpl({required this.remoteDataSource});

  final JobOffersRemoteDataSource remoteDataSource;

  @override
  Future<JobOffersPageDto> getJobOffers({required int enterpriseId, int page = 1, int limit = 10, String? status}) {
    return remoteDataSource.getJobOffers(enterpriseId: enterpriseId, page: page, limit: limit, status: status);
  }

  @override
  Future<Map<String, dynamic>> performJobOfferStatusAction(PerformJobOfferStatusActionInput input) {
    return remoteDataSource.performJobOfferStatusAction(input);
  }

  @override
  Future<Map<String, dynamic>> createJobOffer(CreateJobOfferInput input) {
    return remoteDataSource.createJobOffer(input);
  }
}
