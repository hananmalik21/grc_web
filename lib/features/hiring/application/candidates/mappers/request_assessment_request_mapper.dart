import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/candidates/states/request_assessment_state.dart';
import 'package:grc/features/hiring/domain/models/candidates/request_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';

class RequestAssessmentRequestMapper {
  RequestAssessmentRequestMapper._();

  static RequestAssessmentInput fromState({
    required RequestAssessmentState state,
    required int enterpriseId,
    required String createdBy,
    required List<RecLookupValue> assessmentTypeLookups,
    required List<RecLookupValue> platformLookups,
    required List<RecLookupValue> difficultyLookups,
    required bool isRtl,
  }) {
    return RequestAssessmentInput(
      enterpriseId: enterpriseId,
      candidateGuid: state.candidateGuid,
      assessmentType: _lookupLabel(lookups: assessmentTypeLookups, code: state.assessmentTypeCode!, isRtl: isRtl),
      assessmentTemplate: state.assessmentTemplate.trim(),
      platform: _lookupLabel(lookups: platformLookups, code: state.platformCode!, isRtl: isRtl),
      difficultyLevel: _lookupLabel(lookups: difficultyLookups, code: state.difficultyLevelCode!, isRtl: isRtl),
      durationMinutes: state.durationMinutes!,
      completionDueDate: DateTimeUtils.formatYmd(state.dueDate!),
      skillsJson: List<String>.from(state.skills),
      instructions: state.instructions.trim(),
      createdBy: createdBy,
    );
  }

  static String _lookupLabel({required List<RecLookupValue> lookups, required String code, required bool isRtl}) {
    final label = lookups.labelForCode(code, isRtl: isRtl)?.trim();
    if (label != null && label.isNotEmpty) return label;
    return code.trim();
  }
}
