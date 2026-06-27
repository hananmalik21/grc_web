class RequisitionHiringTeam {
  const RequisitionHiringTeam({
    this.reqHiringTeamId,
    this.reqHiringTeamGuid,
    this.hiringManagerEmployeeId,
    this.hiringManagerName,
    this.recruiterEmployeeId,
    this.recruiterName,
    this.hrbpEmployeeId,
    this.hrbpName,
  });

  final int? reqHiringTeamId;
  final String? reqHiringTeamGuid;
  final int? hiringManagerEmployeeId;
  final String? hiringManagerName;
  final int? recruiterEmployeeId;
  final String? recruiterName;
  final int? hrbpEmployeeId;
  final String? hrbpName;
}
