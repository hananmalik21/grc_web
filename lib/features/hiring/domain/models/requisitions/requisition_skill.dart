class RequisitionSkill {
  const RequisitionSkill({required this.skillName, required this.skillTypeCode, this.displaySequence = 0});

  final String skillName;
  final String skillTypeCode;
  final int displaySequence;
}
