import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/presentation/services/candidate_resume_view_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final candidateResumeOpeningProvider = StateProvider.autoDispose.family<bool, String>((ref, resumeKey) => false);

final candidateResumeViewServiceProvider = Provider<CandidateResumeViewService>((ref) {
  return CandidateResumeViewService(repository: ref.watch(candidatesRepositoryProvider));
});
