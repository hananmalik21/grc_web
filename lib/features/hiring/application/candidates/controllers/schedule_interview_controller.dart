import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/mappers/schedule_interview_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_form_actions.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_mode_rules.dart';
import 'package:grc/features/hiring/application/candidates/states/schedule_interview_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleInterviewNotifier extends AutoDisposeFamilyNotifier<ScheduleInterviewState, String>
    implements ScheduleInterviewFormActions {
  @override
  ScheduleInterviewState build(String candidateGuid) {
    return ScheduleInterviewState(candidateGuid: candidateGuid);
  }

  @override
  void setInterviewType(String? code) {
    state = state.copyWith(
      interviewTypeCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('interviewType'),
      clearSubmitError: true,
    );
  }

  @override
  void setInterviewRound(String round) {
    state = state.copyWith(
      interviewRound: round,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('interviewRound'),
      clearSubmitError: true,
    );
  }

  @override
  void setInterviewMode(String? code) {
    state = state.copyWith(
      interviewModeCode: code,
      meetingLink: ScheduleInterviewModeRules.requiresMeetingLink(code) ? state.meetingLink : '',
      fieldErrors: Map<String, String>.from(state.fieldErrors)
        ..remove('interviewMode')
        ..remove('meetingLink'),
      clearSubmitError: true,
    );
  }

  @override
  void setInterviewDate(DateTime date) {
    state = state.copyWith(
      interviewDate: date,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('date'),
      clearSubmitError: true,
    );
  }

  @override
  void setStartTime(TimeOfDay time) {
    state = state.copyWith(
      startTime: time,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('startTime'),
      clearSubmitError: true,
    );
  }

  @override
  void setEndTime(TimeOfDay time) {
    state = state.copyWith(
      endTime: time,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('endTime'),
      clearSubmitError: true,
    );
  }

  @override
  void setMeetingLink(String value) {
    state = state.copyWith(
      meetingLink: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('meetingLink'),
      clearSubmitError: true,
    );
  }

  @override
  void setAdditionalNotes(String value) {
    state = state.copyWith(additionalNotes: value, clearSubmitError: true);
  }

  @override
  void addInterviewerSlot() {
    state = state.copyWith(interviewers: [...state.interviewers, null], clearSubmitError: true);
  }

  @override
  void removeInterviewerSlot(int index) {
    if (state.interviewers.length <= 1) {
      state = state.copyWith(interviewers: const <Employee?>[null], clearSubmitError: true);
      return;
    }
    final next = List<Employee?>.from(state.interviewers)..removeAt(index);
    state = state.copyWith(interviewers: next, clearSubmitError: true);
  }

  @override
  void setInterviewer(int index, Employee employee) {
    final duplicateIndex = state.interviewers.indexWhere((e) => e?.id == employee.id);
    if (duplicateIndex >= 0 && duplicateIndex != index) {
      state = state.copyWith(
        fieldErrors: {...state.fieldErrors, 'interviewers': 'This employee is already selected'},
        clearSubmitError: true,
      );
      return;
    }

    final next = List<Employee?>.from(state.interviewers);
    if (index >= 0 && index < next.length) {
      next[index] = employee;
      state = state.copyWith(
        interviewers: next,
        fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('interviewers'),
        clearSubmitError: true,
      );
    }
  }

  bool validate() {
    final errors = <String, String>{};
    final type = state.interviewTypeCode?.trim();
    if (type == null || type.isEmpty) {
      errors['interviewType'] = 'Interview type is required';
    }

    final round = state.interviewRound.trim();
    if (!HiringConfig.scheduleInterviewRoundCodes.contains(round)) {
      errors['interviewRound'] = 'Interview round is required';
    }

    final mode = state.interviewModeCode?.trim();
    if (!ScheduleInterviewModeRules.isValid(mode)) {
      errors['interviewMode'] = 'Interview mode is required';
    }

    if (state.interviewDate == null) {
      errors['date'] = 'Date is required';
    }

    if (state.startTime == null) {
      errors['startTime'] = 'Start time is required';
    }

    if (state.endTime == null) {
      errors['endTime'] = 'End time is required';
    }

    if (state.startTime != null && state.endTime != null && !_isEndAfterStart(state.startTime!, state.endTime!)) {
      errors['endTime'] = 'End time must be after start time';
    }

    if (ScheduleInterviewModeRules.requiresMeetingLink(state.interviewModeCode) && state.meetingLink.trim().isEmpty) {
      errors['meetingLink'] = 'Meeting link is required for online or virtual interviews';
    }

    if (state.selectedInterviewers.isEmpty) {
      errors['interviewers'] = 'Select at least one interviewer';
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  bool _isEndAfterStart(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  @override
  Future<bool> submit() async {
    if (!validate()) return false;

    final enterpriseId = ref.read(scheduleInterviewEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(submitError: 'Select an enterprise first');
      return false;
    }

    final typeLookups = ref.read(scheduleInterviewTypeLookupValuesProvider).valueOrNull ?? const [];
    final isRtl = ref.read(localeProvider).languageCode == 'ar';
    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    final input = ScheduleInterviewRequestMapper.fromState(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      typeLookups: typeLookups,
      isRtl: isRtl,
    );

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(scheduleInterviewUseCaseProvider).call(input);

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: state.candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));
      ref.read(interviewsTabRefreshTickProvider.notifier).state++;

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to schedule interview. Please try again.');
      return false;
    }
  }
}
