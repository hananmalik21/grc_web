import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/employee_self_service/presentation/providers/my_payslips/my_payslips_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips/widgets/payslip_filters_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips/widgets/payslip_record_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips/widgets/payslip_summary_stat_card.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyPayslipsTabView extends ConsumerWidget {
  const MyPayslipsTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPayslipsProvider);
    final notifier = ref.read(myPayslipsProvider.notifier);
    final payslips = state.filteredPayslips;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTabHeader(title: state.headerTitle, description: state.headerSubtitle),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 980;

              if (isStacked) {
                return Column(
                  children: [
                    for (var index = 0; index < state.summaryStats.length; index++) ...[
                      PayslipSummaryStatCard(stat: state.summaryStats[index]),
                      if (index != state.summaryStats.length - 1) Gap(16.h),
                    ],
                  ],
                );
              }

              return SizedBox(
                height: 96.h,
                child: Row(
                  children: [
                    for (var index = 0; index < state.summaryStats.length; index++) ...[
                      Expanded(child: PayslipSummaryStatCard(stat: state.summaryStats[index])),
                      if (index != state.summaryStats.length - 1) Gap(20.w),
                    ],
                  ],
                ),
              );
            },
          ),
          Gap(18.h),
          PayslipFiltersCard(
            searchQuery: state.searchQuery,
            selectedYear: state.selectedYear,
            availableYears: state.availableYears,
            onSearchChanged: notifier.setSearchQuery,
            onYearSelected: notifier.setSelectedYear,
          ),
          Gap(18.h),
          EssSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payslips for ${state.selectedYear}',
                        style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp),
                      ),
                      Gap(4.h),
                      Text(
                        '${payslips.length} payslip(s) found',
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                DigifyDivider(margin: EdgeInsets.symmetric(vertical: 20.h)),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 500.h),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var index = 0; index < payslips.length; index++) ...[
                          PayslipRecordCard(
                            record: payslips[index],
                            isExpanded: state.expandedPayslipId == payslips[index].id,
                            onToggleDetails: () => notifier.toggleExpandedPayslip(payslips[index].id),
                          ),
                          if (index != payslips.length - 1) DigifyDivider(margin: EdgeInsets.symmetric(vertical: 16.h)),
                        ],
                        Gap(16.h),
                        PaginationControls(
                          currentPage: state.currentPage,
                          totalPages: state.totalPages,
                          totalItems: state.totalItems,
                          pageSize: state.pageSize,
                          hasNext: state.hasNext,
                          hasPrevious: state.hasPrevious,
                          onPrevious: notifier.previousPage,
                          onNext: notifier.nextPage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
