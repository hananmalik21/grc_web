import 'package:grc/core/models/document_attachment_input.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/mappers/create_candidate_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_education_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_work_experience_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/create_candidate_state.dart';

class CreateCandidateNotifier extends AutoDisposeNotifier<CreateCandidateState> {
  @override
  CreateCandidateState build() => CreateCandidateState(noticePeriod: HiringConfig.noticePeriodOptions[2]);

  void setFirstName(String val) {
    state = state.copyWith(
      firstName: val,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('firstName'),
      clearSubmitError: true,
    );
  }

  void setMiddleName(String val) {
    state = state.copyWith(middleName: val, clearSubmitError: true);
  }

  void setLastName(String val) {
    state = state.copyWith(
      lastName: val,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('lastName'),
      clearSubmitError: true,
    );
  }

  void setEmail(String val) {
    state = state.copyWith(
      email: val,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('email'),
      clearSubmitError: true,
    );
  }

  void setPhone(String val) {
    state = state.copyWith(
      phone: val,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('phone'),
      clearSubmitError: true,
    );
  }

  void setPhoneDialCode(String val) {
    state = state.copyWith(
      phoneDialCode: val,
      phone: '$val${state.phoneNumber}',
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('phone'),
      clearSubmitError: true,
    );
  }

  void setPhoneNumber(String val) {
    state = state.copyWith(
      phoneNumber: val,
      phone: '${state.phoneDialCode}$val',
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('phone'),
      clearSubmitError: true,
    );
  }

  void setCurrentTitle(String val) {
    state = state.copyWith(currentTitle: val, clearSubmitError: true);
  }

  void setCurrentEmployer(String val) {
    state = state.copyWith(currentEmployer: val, clearSubmitError: true);
  }

  void setYearsOfExperience(String val) {
    state = state.copyWith(yearsOfExperience: val, clearSubmitError: true);
  }

  void setCurrentLocation(String val) {
    state = state.copyWith(currentLocation: val, clearSubmitError: true);
  }

  void setSource(String? val) {
    state = state.copyWith(
      source: val,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('source'),
      clearSubmitError: true,
    );
  }

  void setExpectedSalary(String val) {
    state = state.copyWith(expectedSalary: val, clearSubmitError: true);
  }

  void setSalaryCurrency(String? val) {
    state = state.copyWith(salaryCurrency: val, clearSubmitError: true);
  }

  void setNoticePeriod(String val) {
    state = state.copyWith(noticePeriod: val, clearSubmitError: true);
  }

  void setLinkedinProfile(String val) {
    state = state.copyWith(linkedinProfile: val, clearSubmitError: true);
  }

  void setResume(DocumentAttachmentInput? resume) {
    if (resume == null) {
      state = state.copyWith(clearResume: true, clearSubmitError: true);
    } else {
      state = state.copyWith(resume: resume, clearSubmitError: true);
    }
  }

  void addEducation(CreateCandidateEducationInput entry) {
    state = state.copyWith(educationEntries: [...state.educationEntries, entry], clearSubmitError: true);
  }

  void updateEducation(CreateCandidateEducationInput entry) {
    state = state.copyWith(
      educationEntries: [
        for (final item in state.educationEntries)
          if (item.id == entry.id) entry else item,
      ],
      clearSubmitError: true,
    );
  }

  void removeEducation(String id) {
    state = state.copyWith(
      educationEntries: state.educationEntries.where((e) => e.id != id).toList(),
      clearSubmitError: true,
    );
  }

  void addWorkExperience(CreateCandidateWorkExperienceInput entry) {
    state = state.copyWith(workExperienceEntries: [...state.workExperienceEntries, entry], clearSubmitError: true);
  }

  void updateWorkExperience(CreateCandidateWorkExperienceInput entry) {
    state = state.copyWith(
      workExperienceEntries: [
        for (final item in state.workExperienceEntries)
          if (item.id == entry.id) entry else item,
      ],
      clearSubmitError: true,
    );
  }

  void removeWorkExperience(String id) {
    state = state.copyWith(
      workExperienceEntries: state.workExperienceEntries.where((e) => e.id != id).toList(),
      clearSubmitError: true,
    );
  }

  bool validate() {
    final errors = <String, String>{};

    if (state.firstName.trim().isEmpty) {
      errors['firstName'] = 'First name is required';
    }
    if (state.lastName.trim().isEmpty) {
      errors['lastName'] = 'Last name is required';
    }
    if (state.email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(state.email.trim())) {
        errors['email'] = 'Enter a valid email address';
      }
    }
    if (state.phoneNumber.trim().isEmpty) {
      errors['phone'] = 'Phone number is required';
    }
    if (state.source == null || state.source!.trim().isEmpty) {
      errors['source'] = 'Source is required';
    }

    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      errors['enterprise'] = 'Select an enterprise';
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider)!;
    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'SYSTEM';

    final input = CreateCandidateRequestMapper.fromState(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
    );

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(createCandidateUseCaseProvider).call(input);
      ref.read(candidatesControllerProvider).refreshCandidates();
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to create candidate. Please try again.');
      return false;
    }
  }

  void reset() {
    state = CreateCandidateState(noticePeriod: HiringConfig.noticePeriodOptions[2]);
  }
}
