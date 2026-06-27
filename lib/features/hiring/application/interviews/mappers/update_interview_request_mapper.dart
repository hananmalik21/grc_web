import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_mode_rules.dart';
import 'package:grc/features/hiring/application/interviews/states/update_interview_state.dart';
import 'package:grc/features/hiring/domain/models/interview_result_status.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';
import 'package:grc/features/hiring/domain/models/update_interview_input.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class UpdateInterviewRequestMapper {
  UpdateInterviewRequestMapper._();

  static UpdateInterviewInput fromState({
    required UpdateInterviewState state,
    required int enterpriseId,
    required String updatedBy,
    required List<RecLookupValue> typeLookups,
    required bool isRtl,
  }) {
    final typeValue = typeLookups.byCode(state.interviewTypeCode);
    final interviewType = state.interviewTypeCode!.trim().toUpperCase();
    final interviewMode = state.interviewModeCode!.trim().toUpperCase();
    final interviewTitle = _buildInterviewTitle(typeValue, isRtl);
    final interviewRound = int.parse(state.interviewRound.trim());

    final startLocal = DateTimeUtils.combineLocalDateAndTime(state.interviewDate!, state.startTime!);
    final endLocal = DateTimeUtils.combineLocalDateAndTime(state.interviewDate!, state.endTime!);
    final interviewStartUtc = DateTimeUtils.localToUtcIso8601(startLocal);
    final interviewEndUtc = DateTimeUtils.localToUtcIso8601(endLocal);

    final meetingLink = ScheduleInterviewModeRules.requiresMeetingLink(interviewMode)
        ? _optionalTrimmed(state.meetingLink)
        : null;

    final primaryInterviewer = _primaryInterviewer(state.selectedInterviewers);
    final interviewerName = primaryInterviewer != null ? _employeeDisplayName(primaryInterviewer) : null;
    final interviewerEmail = _optionalTrimmed(primaryInterviewer?.email ?? '');

    return UpdateInterviewInput(
      interviewGuid: state.interviewGuid,
      enterpriseId: enterpriseId,
      updatedBy: updatedBy,
      interviewTitle: interviewTitle,
      interviewType: interviewType,
      interviewRound: interviewRound,
      interviewStartUtc: interviewStartUtc,
      interviewEndUtc: interviewEndUtc,
      interviewMode: interviewMode,
      meetingLink: meetingLink,
      interviewerName: interviewerName,
      interviewerEmail: interviewerEmail,
      resultStatus: InterviewResultStatus.pending,
      feedback: _optionalTrimmed(state.additionalNotes),
    );
  }

  static Employee? _primaryInterviewer(List<Employee> interviewers) {
    if (interviewers.isEmpty) return null;
    return interviewers.first;
  }

  static String _employeeDisplayName(Employee employee) {
    return '${employee.firstName} ${employee.lastName}'.trim();
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
