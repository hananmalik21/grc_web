import 'package:grc/features/hiring/application/candidates/states/initiate_background_check_state.dart';
import 'package:grc/features/hiring/domain/models/candidates/initiate_background_check_input.dart';

class InitiateBackgroundCheckRequestMapper {
  InitiateBackgroundCheckRequestMapper._();

  static InitiateBackgroundCheckInput fromState({
    required InitiateBackgroundCheckState state,
    required int enterpriseId,
    required String createdBy,
  }) {
    return InitiateBackgroundCheckInput(
      enterpriseId: enterpriseId,
      candidateGuid: state.candidateGuid,
      provider: state.provider,
      checkType: state.checkType.apiValue,
      employmentVerFlag: _flag(state.isComponentSelected(BackgroundCheckComponent.employment)),
      educationVerFlag: _flag(state.isComponentSelected(BackgroundCheckComponent.education)),
      criminalRecordFlag: _flag(state.isComponentSelected(BackgroundCheckComponent.criminal)),
      creditCheckFlag: _flag(state.isComponentSelected(BackgroundCheckComponent.credit)),
      drugTestingFlag: _flag(state.isComponentSelected(BackgroundCheckComponent.drug)),
      priority: state.priority!,
      additionalNotes: state.additionalNotes.trim().isEmpty ? null : state.additionalNotes.trim(),
      consentObtainedFlag: 'Y',
      createdBy: createdBy,
    );
  }

  static String _flag(bool selected) => selected ? 'Y' : 'N';
}
