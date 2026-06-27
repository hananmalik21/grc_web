import 'package:grc/features/hiring/data/datasources/interviews_remote_data_source.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/submit_interview_feedback_input.dart';
import 'package:grc/features/hiring/domain/models/update_interview_input.dart';
import 'package:grc/features/hiring/domain/repositories/interviews_repository.dart';

class InterviewsRepositoryImpl implements InterviewsRepository {
  const InterviewsRepositoryImpl({required this.remoteDataSource});

  final InterviewsRemoteDataSource remoteDataSource;

  @override
  Future<InterviewsPage> getInterviews({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    final dto = await remoteDataSource.getInterviews(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    return dto.toDomain();
  }

  @override
  Future<Map<String, dynamic>> submitInterviewFeedback(SubmitInterviewFeedbackInput input) {
    return remoteDataSource.submitInterviewFeedback(input);
  }

  @override
  Future<Map<String, dynamic>> updateInterview(UpdateInterviewInput input) {
    return remoteDataSource.updateInterview(input);
  }
}
