class SubmitInterviewFeedbackInput {
  const SubmitInterviewFeedbackInput({
    required this.interviewGuid,
    required this.enterpriseId,
    required this.overallRating,
    required this.createdBy,
    this.technicalSkills,
    this.communication,
    this.cultureFit,
    this.recommendation,
    this.detailedComments,
  });

  final String interviewGuid;
  final int enterpriseId;
  final int overallRating;
  final String? technicalSkills;
  final String? communication;
  final String? cultureFit;
  final String? recommendation;
  final String? detailedComments;
  final String createdBy;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enterprise_id': enterpriseId,
      'overall_rating': overallRating,
      if (technicalSkills != null) 'technical_skills': technicalSkills,
      if (communication != null) 'communication': communication,
      if (cultureFit != null) 'culture_fit': cultureFit,
      if (recommendation != null) 'recommendation': recommendation,
      if (detailedComments != null && detailedComments!.trim().isNotEmpty)
        'detailed_comments': detailedComments!.trim(),
      'created_by': createdBy.trim().isEmpty ? 'ADMIN' : createdBy.trim(),
    };
  }
}
