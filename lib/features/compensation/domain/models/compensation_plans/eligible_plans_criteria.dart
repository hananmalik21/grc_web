class EligiblePlansCriteria {
  final int enterpriseId;
  final int gradeId;
  final String positionId;
  final int jobFamilyId;
  final String orgUnitId;

  const EligiblePlansCriteria({
    required this.enterpriseId,
    required this.gradeId,
    required this.positionId,
    required this.jobFamilyId,
    required this.orgUnitId,
  });
}
