import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/repositories/interviews_repository.dart';

class GetInterviewsUseCase {
  const GetInterviewsUseCase({required this.repository});

  final InterviewsRepository repository;

  Future<InterviewsPage> call({required int enterpriseId, int page = 1, int pageSize = 10}) {
    return repository.getInterviews(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
  }
}
