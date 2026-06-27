class TimesheetStats {
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final double regHours;
  final double otHours;

  const TimesheetStats({
    required this.total,
    required this.draft,
    required this.submitted,
    required this.approved,
    required this.rejected,
    required this.regHours,
    required this.otHours,
  });

  static const empty = TimesheetStats(
    total: 0,
    draft: 0,
    submitted: 0,
    approved: 0,
    rejected: 0,
    regHours: 0.0,
    otHours: 0.0,
  );
}
