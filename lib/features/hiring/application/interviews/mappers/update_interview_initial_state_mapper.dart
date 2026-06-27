import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/interviews/states/update_interview_state.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class UpdateInterviewInitialStateMapper {
  UpdateInterviewInitialStateMapper._();

  static UpdateInterviewState fromInterview(Interview interview, {required int enterpriseId}) {
    final interviewGuid = interview.interviewGuid?.trim() ?? '';

    final interviewers = interview.interviewerDetails
        .map((detail) => _employeeFromInterviewer(detail, enterpriseId: enterpriseId))
        .toList();

    return UpdateInterviewState(
      interviewGuid: interviewGuid,
      candidateGuid: interview.candidateGuid?.trim() ?? '',
      candidateName: interview.candidateName,
      interviewTypeCode: interview.interviewType,
      interviewRound: '${interview.interviewRound ?? 1}',
      interviewModeCode: interview.interviewMode,
      interviewDate: DateTimeUtils.localDateFrom(interview.dateTime),
      startTime: DateTimeUtils.timeOfDayFrom(interview.dateTime),
      endTime: DateTimeUtils.timeOfDayFrom(interview.endDateTime),
      meetingLink: interview.meetingLink ?? '',
      additionalNotes: interview.feedback ?? '',
      interviewers: interviewers.isEmpty ? const <Employee?>[null] : interviewers,
    );
  }

  static Employee _employeeFromInterviewer(InterviewInterviewer interviewer, {required int enterpriseId}) {
    final parts = interviewer.employeeName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : 'Employee';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Employee(
      id: interviewer.employeeId,
      guid: interviewer.employeeGuid,
      enterpriseId: enterpriseId,
      firstName: firstName,
      lastName: lastName,
      email: '',
      status: 'ACTIVE',
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}
