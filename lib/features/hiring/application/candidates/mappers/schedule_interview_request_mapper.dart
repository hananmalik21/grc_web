import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_mode_rules.dart';
import 'package:grc/features/hiring/application/candidates/states/schedule_interview_state.dart';
import 'package:grc/features/hiring/domain/models/candidates/schedule_interview_input.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';

class ScheduleInterviewRequestMapper {
  ScheduleInterviewRequestMapper._();

  static ScheduleInterviewInput fromState({
    required ScheduleInterviewState state,
    required int enterpriseId,
    required String createdBy,
    required List<RecLookupValue> typeLookups,
    required bool isRtl,
  }) {
    final typeValue = typeLookups.byCode(state.interviewTypeCode);
    final interviewType = state.interviewTypeCode!.trim().toUpperCase();
    final interviewMode = state.interviewModeCode!.trim().toUpperCase();
    final interviewTitle = _buildInterviewTitle(typeValue, isRtl);
    final interviewRound = int.parse(state.interviewRound.trim());
    final interviewDate = DateTimeUtils.formatYmd(state.interviewDate!);

    final startLocal = DateTimeUtils.combineLocalDateAndTime(state.interviewDate!, state.startTime!);
    final endLocal = DateTimeUtils.combineLocalDateAndTime(state.interviewDate!, state.endTime!);
    final interviewStartUtc = DateTimeUtils.localToUtcIso8601(startLocal);
    final interviewEndUtc = DateTimeUtils.localToUtcIso8601(endLocal);

    final meetingLink = ScheduleInterviewModeRules.requiresMeetingLink(interviewMode)
        ? _optionalTrimmed(state.meetingLink)
        : null;

    final interviewers = state.selectedInterviewers.asMap().entries.map((entry) {
      return ScheduleInterviewInterviewerInput(
        employeeId: entry.value.id,
        primaryInterviewer: entry.key == 0 ? 'Y' : 'N',
      );
    }).toList();

    return ScheduleInterviewInput(
      enterpriseId: enterpriseId,
      candidateGuid: state.candidateGuid,
      interviewTitle: interviewTitle,
      interviewType: interviewType,
      interviewRound: interviewRound,
      interviewDate: interviewDate,
      interviewStartUtc: interviewStartUtc,
      interviewEndUtc: interviewEndUtc,
      interviewMode: interviewMode,
      meetingLink: meetingLink,
      interviewers: interviewers,
      createdBy: createdBy,
    );
  }

  static String _buildInterviewTitle(RecLookupValue? type, bool isRtl) {
    final label = type?.labelForLocale(isRtl: isRtl).trim();
    if (label != null && label.isNotEmpty) return label;
    final code = type?.lookupCode.trim();
    if (code != null && code.isNotEmpty) return code;
    return 'Interview';
  }

  static String? _optionalTrimmed(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
