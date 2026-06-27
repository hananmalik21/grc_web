class ReportingPersonInfo {
  final String label;
  final String name;
  final String subtitle;

  const ReportingPersonInfo({
    required this.label,
    required this.name,
    required this.subtitle,
  });
}

class EmploymentInfoState {
  final String headerTitle;
  final String headerSubtitle;
  final String businessUnit;
  final String businessUnitSubtitle;
  final String position;
  final String originalHireDate;
  final String seniorityDate;
  final String grade;
  final String step;
  final String workSchedule;
  final String assignmentStatus;
  final String employmentSector;
  final String contractType;
  final String contractEndDate;
  final String overtimeEligibility;
  final String workLocation;
  final ReportingPersonInfo directManager;
  final ReportingPersonInfo myTeam;

  const EmploymentInfoState({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.businessUnit,
    required this.businessUnitSubtitle,
    required this.position,
    required this.originalHireDate,
    required this.seniorityDate,
    required this.grade,
    required this.step,
    required this.workSchedule,
    required this.assignmentStatus,
    required this.employmentSector,
    required this.contractType,
    required this.contractEndDate,
    required this.overtimeEligibility,
    required this.workLocation,
    required this.directManager,
    required this.myTeam,
  });

  EmploymentInfoState copyWith({
    String? headerTitle,
    String? headerSubtitle,
    String? businessUnit,
    String? businessUnitSubtitle,
    String? position,
    String? originalHireDate,
    String? seniorityDate,
    String? grade,
    String? step,
    String? workSchedule,
    String? assignmentStatus,
    String? employmentSector,
    String? contractType,
    String? contractEndDate,
    String? overtimeEligibility,
    String? workLocation,
    ReportingPersonInfo? directManager,
    ReportingPersonInfo? myTeam,
  }) {
    return EmploymentInfoState(
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      businessUnit: businessUnit ?? this.businessUnit,
      businessUnitSubtitle: businessUnitSubtitle ?? this.businessUnitSubtitle,
      position: position ?? this.position,
      originalHireDate: originalHireDate ?? this.originalHireDate,
      seniorityDate: seniorityDate ?? this.seniorityDate,
      grade: grade ?? this.grade,
      step: step ?? this.step,
      workSchedule: workSchedule ?? this.workSchedule,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      employmentSector: employmentSector ?? this.employmentSector,
      contractType: contractType ?? this.contractType,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      overtimeEligibility: overtimeEligibility ?? this.overtimeEligibility,
      workLocation: workLocation ?? this.workLocation,
      directManager: directManager ?? this.directManager,
      myTeam: myTeam ?? this.myTeam,
    );
  }
}

