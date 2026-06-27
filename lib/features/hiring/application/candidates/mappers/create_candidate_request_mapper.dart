import 'package:grc/features/hiring/application/candidates/states/create_candidate_state.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';

class CreateCandidateRequestMapper {
  CreateCandidateRequestMapper._();

  static CreateCandidateRequestInput fromState({
    required CreateCandidateState state,
    required int enterpriseId,
    required String createdBy,
  }) {
    return CreateCandidateRequestInput(
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      firstName: state.firstName.trim(),
      middleName: _optional(state.middleName),
      lastName: state.lastName.trim(),
      email: state.email.trim(),
      phone: state.phone.trim(),
      currentTitle: _optional(state.currentTitle),
      currentEmployer: _optional(state.currentEmployer),
      yearsExperience: _optional(state.yearsOfExperience),
      currentLocation: _optional(state.currentLocation),
      source: state.source!.trim(),
      expectedSalary: _optional(state.expectedSalary),
      salaryCurrency: state.salaryCurrency?.trim(),
      noticePeriod: _optional(state.noticePeriod),
      linkedinProfile: _optional(state.linkedinProfile),
      resume: state.resume,
      educationEntries: state.educationEntries,
      workExperienceEntries: state.workExperienceEntries,
    );
  }

  static String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
