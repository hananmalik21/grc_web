import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';
import 'package:grc/features/hiring/domain/repositories/job_offers_repository.dart';

class PerformJobOfferStatusActionUseCase {
  const PerformJobOfferStatusActionUseCase({required this.repository});

  final JobOffersRepository repository;

  Future<Map<String, dynamic>> call(PerformJobOfferStatusActionInput input) {
    return repository.performJobOfferStatusAction(input);
  }
}
