import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/candidates/states/update_candidate_assessment_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';

class UpdateCandidateAssessmentRequestMapper {
  UpdateCandidateAssessmentRequestMapper._();

  static UpdateCandidateAssessmentInput fromState({
    required UpdateCandidateAssessmentState state,
    required int enterpriseId,
    required String updatedBy,
    required List<RecLookupValue> assessmentTypeLookups,
    required List<RecLookupValue> difficultyLookups,
    required bool isRtl,
  }) {
    return UpdateCandidateAssessmentInput(
      assessmentGuid: state.assessmentGuid,
      enterpriseId: enterpriseId,
      assessmentType: _lookupLabel(lookups: assessmentTypeLookups, code: state.assessmentTypeCode!, isRtl: isRtl),
      difficultyLevel: _lookupLabel(lookups: difficultyLookups, code: state.difficultyLevelCode!, isRtl: isRtl),
      durationMinutes: state.durationMinutes!,
      completionDueDate: DateTimeUtils.formatYmd(state.dueDate!),
      skillsJson: List<String>.from(state.skills),
      instructions: state.instructions.trim(),
      statusCode: HiringConfig.defaultUpdateAssessmentStatusCode,
      updatedBy: updatedBy,
    );
  }

  static String _lookupLabel({required List<RecLookupValue> lookups, required String code, required bool isRtl}) {
    final label = lookups.labelForCode(code, isRtl: isRtl)?.trim();
    if (label != null && label.isNotEmpty) return label;
    return code.trim();
  }
}
