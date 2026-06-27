class EnterpriseStats {
  final int totalStructures;
  final int activeStructures;
  final int componentsInUse;
  final int employeesAssigned;

  const EnterpriseStats({
    required this.totalStructures,
    required this.activeStructures,
    required this.componentsInUse,
    required this.employeesAssigned,
  });

  static const empty = EnterpriseStats(
    totalStructures: 0,
    activeStructures: 0,
    componentsInUse: 0,
    employeesAssigned: 0,
  );

  String get formattedTotalStructures => totalStructures.toString();
  String get formattedActiveStructures => activeStructures.toString();
  String get formattedComponentsInUse => componentsInUse.toString();
  String get formattedEmployeesAssigned => employeesAssigned.toString();
}
