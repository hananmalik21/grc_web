class JobOffer {
  const JobOffer({
    required this.offerId,
    required this.offerGuid,
    required this.enterpriseId,
    required this.offerNumber,
    required this.candidateName,
    required this.jobTitle,
    required this.positionName,
    required this.departmentName,
    required this.location,
    required this.startDate,
    required this.expiryDate,
    required this.annualSalary,
    required this.statusCode,
    required this.gradeName,
    required this.employmentTypeCode,
    required this.workModeCode,
    required this.probationPeriod,
    required this.currencyCode,
  });

  final int offerId;
  final String offerGuid;
  final int enterpriseId;
  final String offerNumber;
  final String candidateName;
  final String jobTitle;
  final String positionName;
  final String departmentName;
  final String location;
  final String startDate;
  final String expiryDate;
  final num annualSalary;
  final String statusCode;
  final String gradeName;
  final String employmentTypeCode;
  final String workModeCode;
  final String probationPeriod;
  final String currencyCode;
}
