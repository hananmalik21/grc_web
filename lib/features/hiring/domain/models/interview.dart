import 'package:grc/features/hiring/domain/models/interview_result_status.dart';

enum InterviewStatus { scheduled, pending, completed, cancelled, rescheduled }

class InterviewsPagination {
  const InterviewsPagination({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}

class InterviewsPage {
  const InterviewsPage({required this.items, required this.pagination});

  final List<Interview> items;
  final InterviewsPagination? pagination;

  static const empty = InterviewsPage(items: [], pagination: null);
}

class InterviewInterviewer {
  const InterviewInterviewer({
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeName,
    required this.primaryInterviewer,
  });

  final int employeeId;
  final String employeeGuid;
  final String employeeName;
  final bool primaryInterviewer;
}

class InterviewFeedback {
  const InterviewFeedback({
    required this.feedbackId,
    required this.feedbackGuid,
    required this.overallRating,
    this.technicalSkills,
    this.communication,
    this.cultureFit,
    this.recommendation,
    this.detailedComments,
  });

  final int feedbackId;
  final String feedbackGuid;
  final int overallRating;
  final String? technicalSkills;
  final String? communication;
  final String? cultureFit;
  final String? recommendation;
  final String? detailedComments;
}

class Interview {
  const Interview({
    required this.id,
    required this.candidateName,
    required this.position,
    required this.status,
    this.statusCode,
    this.dateTime,
    this.endDateTime,
    this.interviewType,
    this.interviewRound,
    this.interviewers = const [],
    required this.roundInfo,
    this.meetingLink,
    this.interviewGuid,
    this.candidateGuid,
    this.candidateId,
    this.resultStatus,
    this.rating,
    this.feedback,
    this.interviewTitle,
    this.interviewMode,
    this.interviewerDetails = const [],
    this.feedbackDetail,
  });

  final int id;
  final String candidateName;
  final String position;
  final InterviewStatus status;
  final String? statusCode;
  final DateTime? dateTime;
  final DateTime? endDateTime;
  final String? interviewType;
  final int? interviewRound;
  final List<String> interviewers;
  final String roundInfo;
  final String? meetingLink;
  final String? interviewGuid;
  final String? candidateGuid;
  final int? candidateId;
  final String? resultStatus;
  final int? rating;
  final String? feedback;
  final String? interviewTitle;
  final String? interviewMode;
  final List<InterviewInterviewer> interviewerDetails;
  final InterviewFeedback? feedbackDetail;

  String get statusLabel => resultStatus ?? statusCode ?? status.name.toUpperCase();

  bool get allowsEditAndReject => InterviewResultStatus.allowsEditAndReject(resultStatus);
}
