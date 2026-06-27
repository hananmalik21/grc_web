import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/controllers/create_candidate_controller.dart';
import 'package:grc/features/hiring/application/candidates/mappers/candidate_form_seed_mapper.dart';
import 'package:grc/features/hiring/application/candidates/mappers/create_candidate_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/candidates/update_candidate_session.dart';
import 'package:grc/features/hiring/application/candidates/states/create_candidate_state.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_request_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateCandidateSessionProvider = Provider<UpdateCandidateSession>(
  (ref) => throw StateError('UpdateCandidateSession was not provided'),
);

class UpdateCandidateNotifier extends CreateCandidateNotifier {
  @override
  CreateCandidateState build() {
    final session = ref.read(updateCandidateSessionProvider);
    return CandidateFormSeedMapper.fromCandidate(session.candidate);
  }

  @override
  Future<bool> submit() async {
    if (!validate()) return false;

    final session = ref.read(updateCandidateSessionProvider);
    final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'SYSTEM';

    final payload = CreateCandidateRequestMapper.fromState(
      state: state,
      enterpriseId: session.enterpriseId,
      createdBy: updatedBy,
    );

    final input = UpdateCandidateRequestInput(candidateGuid: session.candidateGuid, payload: payload);

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(updateCandidateUseCaseProvider).call(input);
      ref.read(candidatesControllerProvider).refreshCandidates();
      ref.invalidate(
        getCandidateDetailProvider(
          GetCandidateDetailParams(enterpriseId: session.enterpriseId, candidateGuid: session.candidateGuid),
        ),
      );
      ref.invalidate(
        getCandidateDetailDataProvider(
          GetCandidateDetailParams(enterpriseId: session.enterpriseId, candidateGuid: session.candidateGuid),
        ),
      );
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to update candidate. Please try again.');
      return false;
    }
  }
}
