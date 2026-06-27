class RejectApplicationInput {
  const RejectApplicationInput({
    required this.applicationGuid,
    required this.enterpriseId,
    required this.rejectionReasonCode,
    this.rejectionComments,
    required this.sendEmail,
    required this.rejectedBy,
  });

  final String applicationGuid;
  final int enterpriseId;
  final String rejectionReasonCode;
  final String? rejectionComments;
  final bool sendEmail;
  final String rejectedBy;

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'enterprise_id': enterpriseId,
      'rejection_reason_code': rejectionReasonCode.trim().toUpperCase(),
      'send_email_flag': sendEmail ? 'Y' : 'N',
      'rejected_by': rejectedBy.trim().isEmpty ? 'ADMIN' : rejectedBy.trim(),
    };
    final comments = rejectionComments?.trim();
    if (comments != null && comments.isNotEmpty) {
      body['rejection_comments'] = comments.length > 4000 ? comments.substring(0, 4000) : comments;
    }
    return body;
  }
}
