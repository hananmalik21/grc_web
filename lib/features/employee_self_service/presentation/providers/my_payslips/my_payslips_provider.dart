import 'package:grc/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_payslips_state.dart';

class MyPayslipsNotifier extends StateNotifier<MyPayslipsState> {
  MyPayslipsNotifier() : super(_initial());

  static MyPayslipsState _initial() {
    return MyPayslipsState(
      headerTitle: 'My Payslips',
      headerSubtitle: 'View and download your salary statements',
      summaryStats: [
        PayslipSummaryStat(label: 'YTD Gross Pay', value: '0.000 KWD', iconPath: Assets.icons.metricsIcon.path),
        PayslipSummaryStat(label: 'YTD Net Pay', value: '0.000 KWD', iconPath: Assets.icons.budgetIcon.path),
        PayslipSummaryStat(
          label: 'YTD Deductions',
          value: '0.000 KWD',
          iconPath: Assets.icons.employeeManagement.card.path,
        ),
      ],
      searchQuery: '',
      selectedYear: 2026,
      availableYears: const [2026, 2025, 2024],
      allPayslips: const [
        PayslipRecord(
          id: 'jan_2026',
          period: PayslipPeriodInfo(
            monthLabel: 'January 2026',
            periodLabel: 'Jan 1 - Jan 31, 2026',
            statusLabel: 'Processing',
          ),
          breakdown: [
            PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
            PayslipBreakdownItem(label: 'Total Allowances', value: '650.000 KWD'),
            PayslipBreakdownItem(label: 'Total Deductions', value: '-230.000 KWD', isNegative: true),
            PayslipBreakdownItem(label: 'Net Pay', value: '2220.000 KWD', isHighlighted: true),
          ],
          detailedBreakdown: PayslipDetailedBreakdown(
            earnings: [
              PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
              PayslipBreakdownItem(label: 'Housing Allowance', value: '400.000 KWD'),
              PayslipBreakdownItem(label: 'Transport Allowance', value: '150.000 KWD'),
            ],
            grossEarnings: '2450.000 KWD',
            deductions: [
              PayslipBreakdownItem(label: 'PIFSS (Social Security)', value: '-180.000 KWD', isNegative: true),
              PayslipBreakdownItem(label: 'Advance/Loan Recovery', value: '-50.000 KWD', isNegative: true),
            ],
            totalDeductions: '-230.000 KWD',
            netTransferAmount: '2220.000 KWD',
            disbursementMethod: '****7890 (NBK)',
          ),
        ),
        PayslipRecord(
          id: 'feb_2026',
          period: PayslipPeriodInfo(
            monthLabel: 'February 2026',
            periodLabel: 'Feb 1 - Feb 28, 2026',
            statusLabel: 'Paid',
          ),
          breakdown: [
            PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
            PayslipBreakdownItem(label: 'Total Allowances', value: '650.000 KWD'),
            PayslipBreakdownItem(label: 'Total Deductions', value: '-190.000 KWD', isNegative: true),
            PayslipBreakdownItem(label: 'Net Pay', value: '2260.000 KWD', isHighlighted: true),
          ],
          detailedBreakdown: PayslipDetailedBreakdown(
            earnings: [
              PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
              PayslipBreakdownItem(label: 'Housing Allowance', value: '400.000 KWD'),
              PayslipBreakdownItem(label: 'Transport Allowance', value: '150.000 KWD'),
            ],
            grossEarnings: '2350.000 KWD',
            deductions: [
              PayslipBreakdownItem(label: 'PIFSS (Social Security)', value: '-150.000 KWD', isNegative: true),
              PayslipBreakdownItem(label: 'Advance/Loan Recovery', value: '-40.000 KWD', isNegative: true),
            ],
            totalDeductions: '-190.000 KWD',
            netTransferAmount: '2260.000 KWD',
            disbursementMethod: '****7890 (NBK)',
          ),
        ),
        PayslipRecord(
          id: 'mar_2026',
          period: PayslipPeriodInfo(monthLabel: 'March 2026', periodLabel: 'Mar 1 - Mar 31, 2026', statusLabel: 'Paid'),
          breakdown: [
            PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
            PayslipBreakdownItem(label: 'Total Allowances', value: '700.000 KWD'),
            PayslipBreakdownItem(label: 'Total Deductions', value: '-210.000 KWD', isNegative: true),
            PayslipBreakdownItem(label: 'Net Pay', value: '2290.000 KWD', isHighlighted: true),
          ],
          detailedBreakdown: PayslipDetailedBreakdown(
            earnings: [
              PayslipBreakdownItem(label: 'Basic Salary', value: '1800.000 KWD'),
              PayslipBreakdownItem(label: 'Housing Allowance', value: '450.000 KWD'),
              PayslipBreakdownItem(label: 'Transport Allowance', value: '250.000 KWD'),
            ],
            grossEarnings: '2500.000 KWD',
            deductions: [
              PayslipBreakdownItem(label: 'PIFSS (Social Security)', value: '-180.000 KWD', isNegative: true),
              PayslipBreakdownItem(label: 'Advance/Loan Recovery', value: '-30.000 KWD', isNegative: true),
            ],
            totalDeductions: '-210.000 KWD',
            netTransferAmount: '2290.000 KWD',
            disbursementMethod: '****7890 (NBK)',
          ),
        ),
      ],
      currentPage: 1,
      pageSize: 10,
      expandedPayslipId: null,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year, clearExpandedPayslipId: true);
  }

  void goToPage(int page) {
    state = state.copyWith(currentPage: page.clamp(1, state.totalPages));
  }

  void nextPage() => goToPage(state.currentPage + 1);

  void previousPage() => goToPage(state.currentPage - 1);

  void toggleExpandedPayslip(String payslipId) {
    if (state.expandedPayslipId == payslipId) {
      state = state.copyWith(clearExpandedPayslipId: true);
      return;
    }

    state = state.copyWith(expandedPayslipId: payslipId);
  }
}

final myPayslipsProvider = StateNotifierProvider<MyPayslipsNotifier, MyPayslipsState>((ref) {
  return MyPayslipsNotifier();
});
