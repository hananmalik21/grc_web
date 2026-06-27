import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/mappers/update_candidate_assessment_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/request_assessment_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/states/update_candidate_assessment_state.dart';
import 'package:grc/features/hiring/application/candidates/update_candidate_assessment_args.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCandidateAssessmentNotifier
    extends AutoDisposeFamilyNotifier<UpdateCandidateAssessmentState, UpdateCandidateAssessmentArgs> {
  bool _lookupsApplied = false;

  @override
  UpdateCandidateAssessmentState build(UpdateCandidateAssessmentArgs args) {
    ref.listen(requestAssessmentTypeLookupValuesProvider, (previous, next) => _applyLookups(args));
    ref.listen(requestAssessmentDifficultyLookupValuesProvider, (previous, next) => _applyLookups(args));

    return _partialState(args.assessment, candidateGuid: args.candidateGuid);
  }

  void _applyLookups(UpdateCandidateAssessmentArgs args) {
    if (_lookupsApplied) return;

    final assessmentTypeLookups = ref.read(requestAssessmentTypeLookupValuesProvider).valueOrNull;
    final difficultyLookups = ref.read(requestAssessmentDifficultyLookupValuesProvider).valueOrNull;

    if (assessmentTypeLookups == null || difficultyLookups == null) {
      return;
    }

    _lookupsApplied = true;
    final isRtl = ref.read(localeProvider).languageCode == 'ar';
    state = _seededState(
      assessment: args.assessment,
      candidateGuid: args.candidateGuid,
      assessmentTypeLookups: assessmentTypeLookups,
      difficultyLookups: difficultyLookups,
      isRtl: isRtl,
    );
  }

  static UpdateCandidateAssessmentState _partialState(
    CandidateAssessmentData assessment, {
    required String candidateGuid,
  }) {
    final duration = assessment.durationMinutes;
    final resolvedDuration = duration != null && HiringConfig.requestAssessmentDurationMinutes.contains(duration)
        ? duration
        : null;

    return UpdateCandidateAssessmentState(
      candidateGuid: candidateGuid,
      assessmentGuid: assessment.assessmentGuid,
      durationMinutes: resolvedDuration,
      dueDate: assessment.completionDueDate,
      instructions: assessment.feedback,
      skills: List<String>.from(assessment.skills),
    );
  }

  static UpdateCandidateAssessmentState _seededState({
    required CandidateAssessmentData assessment,
    required String candidateGuid,
    required List<RecLookupValue> assessmentTypeLookups,
    required List<RecLookupValue> difficultyLookups,
    required bool isRtl,
  }) {
    return UpdateCandidateAssessmentState(
      candidateGuid: candidateGuid,
      assessmentGuid: assessment.assessmentGuid,
      assessmentTypeCode: assessmentTypeLookups.codeForLabel(assessment.title, isRtl: isRtl),
      difficultyLevelCode: difficultyLookups.codeForLabel(assessment.difficultyLevel, isRtl: isRtl),
      durationMinutes: _partialState(assessment, candidateGuid: candidateGuid).durationMinutes,
      dueDate: assessment.completionDueDate,
      instructions: assessment.feedback,
      skills: List<String>.from(assessment.skills),
    );
  }

  void setAssessmentType(String? code) {
    state = state.copyWith(
      assessmentTypeCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('assessmentType'),
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

  bool validate() {
    final errors = <String, String>{};

    final type = state.assessmentTypeCode?.trim();
    if (type == null || type.isEmpty) {
      errors['assessmentType'] = 'Assessment type is required';
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
    final difficultyLookups = ref.read(requestAssessmentDifficultyLookupValuesProvider).valueOrNull ?? const [];
    final isRtl = ref.read(localeProvider).languageCode == 'ar';
    final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    final input = UpdateCandidateAssessmentRequestMapper.fromState(
      state: state,
      enterpriseId: enterpriseId,
      updatedBy: updatedBy,
      assessmentTypeLookups: assessmentTypeLookups,
      difficultyLookups: difficultyLookups,
      isRtl: isRtl,
    );

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(updateCandidateAssessmentUseCaseProvider).call(input);

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: state.candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to update assessment. Please try again.');
      return false;
    }
  }
}
