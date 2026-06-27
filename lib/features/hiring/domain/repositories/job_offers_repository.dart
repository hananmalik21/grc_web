import 'package:grc/features/hiring/data/dto/job_offers_dto.dart';
import 'package:grc/features/hiring/domain/models/job_offers/create_job_offer_input.dart';
import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';

abstract class JobOffersRepository {
  Future<JobOffersPageDto> getJobOffers({required int enterpriseId, int page = 1, int limit = 10, String? status});

  Future<Map<String, dynamic>> performJobOfferStatusAction(PerformJobOfferStatusActionInput input);

  Future<Map<String, dynamic>> createJobOffer(CreateJobOfferInput input);
}
