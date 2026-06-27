import 'package:grc/features/hiring/domain/models/job_offers/create_job_offer_input.dart';
import 'package:grc/features/hiring/domain/repositories/job_offers_repository.dart';

class CreateJobOfferUseCase {
  const CreateJobOfferUseCase({required this.repository});

  final JobOffersRepository repository;

  Future<Map<String, dynamic>> call(CreateJobOfferInput input) {
    return repository.createJobOffer(input);
  }
}
