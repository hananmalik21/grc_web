import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/mappers/request_assessment_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/request_assessment_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/states/request_assessment_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestAssessmentNotifier extends AutoDisposeFamilyNotifier<RequestAssessmentState, String> {
  @override
  RequestAssessmentState build(String candidateGuid) {
    return RequestAssessmentState(candidateGuid: candidateGuid);
  }

  void setAssessmentType(String? code) {
    state = state.copyWith(
      assessmentTypeCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('assessmentType'),
      clearSubmitError: true,
    );
  }

  void setPlatform(String? code) {
    state = state.copyWith(
      platformCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('platform'),
      clearSubmitError: true,
    );
  }

  void setDifficultyLevel(String? code) {
    state = state.copyWith(
      difficultyLevelCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('difficultyLevel'),
      clearSubmitError: true,
    );
  }

  void setDurationMinutes(int? minutes) {
    state = state.copyWith(
      durationMinutes: minutes,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('duration'),
      clearSubmitError: true,
    );
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(
      dueDate: date,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('dueDate'),
      clearSubmitError: true,
    );
  }

  void setAssessmentTemplate(String value) {
    state = state.copyWith(assessmentTemplate: value, clearSubmitError: true);
  }

  void setInstructions(String value) {
    state = state.copyWith(instructions: value, clearSubmitError: true);
  }

  bool addSkill(String raw) {
    final skill = raw.trim();
    if (skill.isEmpty) return false;

    final isDuplicate = state.skills.any((s) => s.toLowerCase() == skill.toLowerCase());
    if (isDuplicate) return false;

    state = state.copyWith(
      skills: [...state.skills, skill],
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('skills'),
      clearSubmitError: true,
    );
    return true;
  }

  void removeSkill(String skill) {
    state = state.copyWith(skills: state.skills.where((s) => s != skill).toList(), clearSubmitError: true);
  }

  void reset() {
    state = RequestAssessmentState(candidateGuid: state.candidateGuid);
  }

  bool validate() {
    final errors = <String, String>{};

    final type = state.assessmentTypeCode?.trim();
    if (type == null || type.isEmpty) {
      errors['assessmentType'] = 'Assessment type is required';
    }

    final platform = state.platformCode?.trim();
    if (platform == null || platform.isEmpty) {
      errors['platform'] = 'Platform is required';
    }

    final difficulty = state.difficultyLevelCode?.trim();
    if (difficulty == null || difficulty.isEmpty) {
      errors['difficultyLevel'] = 'Difficulty level is required';
    }

    final duration = state.durationMinutes;
    if (duration == null || !HiringConfig.requestAssessmentDurationMinutes.contains(duration)) {
      errors['duration'] = 'Duration is required';
    }

    if (state.dueDate == null) {
      errors['dueDate'] = 'Completion due date is required';
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(submitError: 'Select an enterprise first');
      return false;
    }

    final assessmentTypeLookups = ref.read(requestAssessmentTypeLookupValuesProvider).valueOrNull ?? const [];
    final platformLookups = ref.read(requestAssessmentPlatformLookupValuesProvider).valueOrNull ?? const [];
    final difficultyLookups = ref.read(requestAssessmentDifficultyLookupValuesProvider).valueOrNull ?? const [];
    final isRtl = ref.read(localeProvider).languageCode == 'ar';
    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    final input = RequestAssessmentRequestMapper.fromState(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
      assessmentTypeLookups: assessmentTypeLookups,
      platformLookups: platformLookups,
      difficultyLookups: difficultyLookups,
      isRtl: isRtl,
    );

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(requestAssessmentUseCaseProvider).call(input);

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: state.candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to send assessment request. Please try again.');
      return false;
    }
  }
}
