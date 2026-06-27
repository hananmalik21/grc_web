class UpdateInterviewInput {
  const UpdateInterviewInput({
    required this.interviewGuid,
    required this.enterpriseId,
    required this.updatedBy,
    this.interviewTitle,
    this.interviewType,
    this.interviewRound,
    this.interviewStartUtc,
    this.interviewEndUtc,
    this.interviewMode,
    this.location,
    this.meetingLink,
    this.interviewerName,
    this.interviewerEmail,
    this.resultStatus,
    this.feedback,
    this.rating,
  });

  final String interviewGuid;
  final int enterpriseId;
  final String updatedBy;
  final String? interviewTitle;
  final String? interviewType;
  final int? interviewRound;
  final String? interviewStartUtc;
  final String? interviewEndUtc;
  final String? interviewMode;
  final String? location;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewerEmail;
  final String? resultStatus;
  final String? feedback;
  final int? rating;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'enterprise_id': enterpriseId, 'updated_by': updatedBy};

    if (interviewTitle != null) {
      json['interview_title'] = interviewTitle;
    }
    if (interviewType != null) {
      json['interview_type'] = interviewType;
    }
    if (interviewRound != null) {
      json['interview_round'] = interviewRound;
    }
    if (interviewStartUtc != null) {
      json['interview_start_utc'] = interviewStartUtc;
    }
    if (interviewEndUtc != null) {
      json['interview_end_utc'] = interviewEndUtc;
    }
    if (interviewMode != null) {
      json['interview_mode'] = interviewMode;
    }
    if (location != null) {
      json['location'] = location;
    }
    if (meetingLink != null) {
      json['meeting_link'] = meetingLink;
    }
    if (interviewerName != null) {
      json['interviewer_name'] = interviewerName;
    }
    if (interviewerEmail != null) {
      json['interviewer_email'] = interviewerEmail;
    }
    if (resultStatus != null) {
      json['result_status'] = resultStatus;
    }
    if (feedback != null) {
      json['feedback'] = feedback;
    }
    if (rating != null) {
      json['rating'] = rating;
    }

    return json;
  }
}
