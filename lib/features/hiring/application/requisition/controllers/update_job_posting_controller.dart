import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/requisition/mappers/update_job_posting_request_mapper.dart';
import 'package:grc/features/hiring/application/requisition/providers/job_postings_api_providers.dart';
import 'package:grc/features/hiring/application/requisition/providers/update_job_posting_enterprise_provider.dart';
import 'package:grc/features/hiring/application/requisition/states/update_job_posting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateJobPostingNotifier extends AutoDisposeFamilyNotifier<UpdateJobPostingState, String> {
  @override
  UpdateJobPostingState build(String postingGuid) {
    return UpdateJobPostingState(postingGuid: postingGuid, requisitionGuid: '');
  }

  void applyInitialState(UpdateJobPostingState initial) {
    if (state.postingGuid != initial.postingGuid) return;
    state = initial;
  }

  void setPostingTitle(String value) {
    state = state.copyWith(
      postingTitle: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('postingTitle'),
      clearSubmitError: true,
    );
  }

  void setPostingDescription(String value) {
    state = state.copyWith(
      postingDescription: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('postingDescription'),
      clearSubmitError: true,
    );
  }

  void setAboutTheRole(String value) {
    state = state.copyWith(
      aboutTheRole: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('aboutTheRole'),
      clearSubmitError: true,
    );
  }

  void setResponsibilitiesText(String value) {
    state = state.copyWith(
      responsibilitiesText: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('responsibilitiesText'),
      clearSubmitError: true,
    );
  }

  void setQualificationsText(String value) {
    state = state.copyWith(
      qualificationsText: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('qualificationsText'),
      clearSubmitError: true,
    );
  }

  void setStartDate(DateTime date) {
    DateTime? adjustedEndDate = state.endDate;
    if (adjustedEndDate != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(adjustedEndDate.year, adjustedEndDate.month, adjustedEndDate.day);
      if (end.isBefore(start)) {
        adjustedEndDate = null;
      }
    }

    state = state.copyWith(
      startDate: date,
      endDate: adjustedEndDate,
      fieldErrors: Map<String, String>.from(state.fieldErrors)
        ..remove('startDate')
        ..remove('endDate'),
      clearSubmitError: true,
    );
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(
      endDate: date,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('endDate'),
      clearSubmitError: true,
    );
  }

  void setInternalSiteFlag(String flag) {
    state = state.copyWith(internalSiteFlag: flag, clearSubmitError: true);
  }

  void setExternalSiteFlag(String flag) {
    state = state.copyWith(externalSiteFlag: flag, clearSubmitError: true);
  }

  void setLinkedinFlag(String flag) {
    state = state.copyWith(linkedinFlag: flag, clearSubmitError: true);
  }

  bool validate() {
    final errors = <String, String>{};

    if (state.postingTitle.trim().isEmpty) {
      errors['postingTitle'] = 'Posting title is required';
    }

    if (state.aboutTheRole.trim().isEmpty) {
      errors['aboutTheRole'] = 'About the role is required';
    }

    if (state.responsibilitiesText.trim().isEmpty) {
      errors['responsibilitiesText'] = 'Responsibilities are required';
    }

    if (state.qualificationsText.trim().isEmpty) {
      errors['qualificationsText'] = 'Qualifications are required';
    }

    if (state.startDate == null) {
      errors['startDate'] = 'Start date is required';
    }

    if (state.startDate != null && state.endDate != null) {
      final start = DateTime(state.startDate!.year, state.startDate!.month, state.startDate!.day);
      final end = DateTime(state.endDate!.year, state.endDate!.month, state.endDate!.day);
      if (end.isBefore(start)) {
        errors['endDate'] = 'End date must be the same or after start date';
      }
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    final enterpriseId = ref.read(updateJobPostingEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(submitError: 'Select an enterprise first');
      return false;
    }

    final lastUpdatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final input = UpdateJobPostingRequestMapper.fromState(
        state: state,
        enterpriseId: enterpriseId,
        lastUpdatedBy: lastUpdatedBy,
      );

      await ref.read(updateJobPostingUseCaseProvider).call(input);
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to update job posting. Please try again.');
      return false;
    }
  }
}
