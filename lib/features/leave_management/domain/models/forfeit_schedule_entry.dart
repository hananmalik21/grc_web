class ForfeitScheduleEntry {
  final String id;
  final String month;
  final String year;
  final int employeeCount;
  final double totalDays;
  final ForfeitScheduleStatus status;

  const ForfeitScheduleEntry({
    required this.id,
    required this.month,
    required this.year,
    required this.employeeCount,
    required this.totalDays,
    required this.status,
  });

  String get monthYear => '$month $year';

  ForfeitScheduleEntry copyWith({
    String? id,
    String? month,
    String? year,
    int? employeeCount,
    double? totalDays,
    ForfeitScheduleStatus? status,
  }) {
    return ForfeitScheduleEntry(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      employeeCount: employeeCount ?? this.employeeCount,
      totalDays: totalDays ?? this.totalDays,
      status: status ?? this.status,
    );
  }
}

enum ForfeitScheduleStatus { readyToProcess, scheduled }
