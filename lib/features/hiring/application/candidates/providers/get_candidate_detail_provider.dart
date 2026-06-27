import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetCandidateDetailParams {
  const GetCandidateDetailParams({required this.enterpriseId, required this.candidateGuid});

  final int enterpriseId;
  final String candidateGuid;

  @override
  bool operator ==(Object other) {
    return other is GetCandidateDetailParams &&
        other.enterpriseId == enterpriseId &&
        other.candidateGuid == candidateGuid;
  }

  @override
  int get hashCode => Object.hash(enterpriseId, candidateGuid);
}

final getCandidateDetailProvider = FutureProvider.autoDispose.family<Candidate, GetCandidateDetailParams>((
  ref,
  params,
) async {
  final useCase = ref.watch(getCandidateByGuidUseCaseProvider);
  return useCase(candidateGuid: params.candidateGuid, enterpriseId: params.enterpriseId);
});

final getCandidateDetailDataProvider = FutureProvider.autoDispose.family<CandidateData, GetCandidateDetailParams>((
  ref,
  params,
) async {
  final candidate = await ref.watch(getCandidateDetailProvider(params).future);
  return candidate.toCandidateData();
});
