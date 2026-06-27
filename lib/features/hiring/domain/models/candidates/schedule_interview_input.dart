import 'package:grc/features/hiring/domain/models/interview_result_status.dart';

class ScheduleInterviewInterviewerInput {
  const ScheduleInterviewInterviewerInput({required this.employeeId, required this.primaryInterviewer});

  final int employeeId;
  final String primaryInterviewer;

  Map<String, dynamic> toJson() => {'employee_id': employeeId, 'primary_interviewer': primaryInterviewer};
}

class ScheduleInterviewInput {
  const ScheduleInterviewInput({
    required this.enterpriseId,
    required this.candidateGuid,
    required this.interviewTitle,
    required this.interviewType,
    required this.interviewRound,
    required this.interviewDate,
    required this.interviewStartUtc,
    required this.interviewEndUtc,
    required this.interviewMode,
    required this.interviewers,
    required this.createdBy,
    this.meetingLink,
  });

  final int enterpriseId;
  final String candidateGuid;
  final String interviewTitle;
  final String interviewType;
  final int interviewRound;
  final String interviewDate;
  final String interviewStartUtc;
  final String interviewEndUtc;
  final String interviewMode;
  final String? meetingLink;
  final List<ScheduleInterviewInterviewerInput> interviewers;
  final String createdBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'candidate_guid': candidateGuid,
    'interview_title': interviewTitle,
    'interview_type': interviewType,
    'interview_round': interviewRound,
    'interview_date': interviewDate,
    'interview_start_utc': interviewStartUtc,
    'interview_end_utc': interviewEndUtc,
    'interview_mode': interviewMode,
    if (meetingLink != null) 'meeting_link': meetingLink,
    'interviewers': interviewers.map((i) => i.toJson()).toList(),
    'created_by': createdBy,
    'result_status': InterviewResultStatus.pending,
  };
}
