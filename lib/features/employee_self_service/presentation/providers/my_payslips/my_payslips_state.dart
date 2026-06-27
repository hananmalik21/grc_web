class PayslipSummaryStat {
  final String label;
  final String value;
  final String iconPath;

  const PayslipSummaryStat({
    required this.label,
    required this.value,
    required this.iconPath,
  });
}

class PayslipPeriodInfo {
  final String monthLabel;
  final String periodLabel;
  final String statusLabel;

  const PayslipPeriodInfo({
    required this.monthLabel,
    required this.periodLabel,
    required this.statusLabel,
  });
}

class PayslipBreakdownItem {
  final String label;
  final String value;
  final bool isNegative;
  final bool isHighlighted;

  const PayslipBreakdownItem({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isHighlighted = false,
  });
}

class PayslipDetailedBreakdown {
  final List<PayslipBreakdownItem> earnings;
  final String grossEarnings;
  final List<PayslipBreakdownItem> deductions;
  final String totalDeductions;
  final String netTransferAmount;
  final String disbursementMethod;

  const PayslipDetailedBreakdown({
    required this.earnings,
    required this.grossEarnings,
    required this.deductions,
    required this.totalDeductions,
    required this.netTransferAmount,
    required this.disbursementMethod,
  });
}

class PayslipRecord {
  final String id;
  final PayslipPeriodInfo period;
  final List<PayslipBreakdownItem> breakdown;
  final PayslipDetailedBreakdown detailedBreakdown;

  const PayslipRecord({
    required this.id,
    required this.period,
    required this.breakdown,
    required this.detailedBreakdown,
  });
}

class MyPayslipsState {
  final String headerTitle;
  final String headerSubtitle;
  final List<PayslipSummaryStat> summaryStats;
  final String searchQuery;
  final int selectedYear;
  final List<int> availableYears;
  final List<PayslipRecord> allPayslips;
  final int currentPage;
  final int pageSize;
  final String? expandedPayslipId;

  const MyPayslipsState({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.summaryStats,
    required this.searchQuery,
    required this.selectedYear,
    required this.availableYears,
    required this.allPayslips,
    required this.currentPage,
    required this.pageSize,
    required this.expandedPayslipId,
  });

  List<PayslipRecord> get filteredPayslips {
    final query = searchQuery.trim().toLowerCase();
    return allPayslips.where((record) {
      final matchesYear = record.period.monthLabel.contains(selectedYear.toString());
      if (!matchesYear) return false;
      if (query.isEmpty) return true;

      return record.period.monthLabel.toLowerCase().contains(query) ||
          record.period.periodLabel.toLowerCase().contains(query) ||
          record.period.statusLabel.toLowerCase().contains(query);
    }).toList();
  }

  int get totalItems => filteredPayslips.length;

  int get totalPages => totalItems == 0 ? 1 : (totalItems / pageSize).ceil();

  bool get hasPrevious => currentPage > 1;

  bool get hasNext => currentPage < totalPages;

  MyPayslipsState copyWith({
    String? headerTitle,
    String? headerSubtitle,
    List<PayslipSummaryStat>? summaryStats,
    String? searchQuery,
    int? selectedYear,
    List<int>? availableYears,
    List<PayslipRecord>? allPayslips,
    int? currentPage,
    int? pageSize,
    String? expandedPayslipId,
    bool clearExpandedPayslipId = false,
  }) {
    return MyPayslipsState(
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      summaryStats: summaryStats ?? this.summaryStats,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedYear: selectedYear ?? this.selectedYear,
      availableYears: availableYears ?? this.availableYears,
      allPayslips: allPayslips ?? this.allPayslips,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      expandedPayslipId: clearExpandedPayslipId ? null : expandedPayslipId ?? this.expandedPayslipId,
    );
  }
}
