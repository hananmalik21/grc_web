import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/leave_absence_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/leave_absence/dialogs/ess_leave_request_dialog.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/leave_absence/widgets/leave_absence_filters_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/leave_absence/widgets/leave_absence_request_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/leave_absence/widgets/leave_absence_summary_stat_card.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveAbsenceTabView extends ConsumerWidget {
  const LeaveAbsenceTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaveAbsenceProvider);
    final notifier = ref.read(leaveAbsenceProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTabHeader(
            title: state.headerTitle,
            description: state.headerSubtitle,
            trailing: AppButton.primary(
              label: 'New Leave Request',
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () => EssLeaveRequestDialog.show(context),
            ),
          ),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 900;

              if (isStacked) {
                return Column(
                  children: [
                    for (var index = 0; index < state.balances.length; index++) ...[
                      LeaveAbsenceSummaryStatCard(stat: state.balances[index]),
                      if (index != state.balances.length - 1) Gap(12.h),
                    ],
                  ],
                );
              }

              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: state.balances
                    .map(
                      (stat) => SizedBox(
                        width: (constraints.maxWidth - (12.w * 5)) / 6,
                        child: LeaveAbsenceSummaryStatCard(stat: stat),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          Gap(18.h),
          LeaveAbsenceFiltersCard(
            searchQuery: state.searchQuery,
            selectedStatus: state.selectedStatus,
            onSearchChanged: notifier.setSearchQuery,
            onStatusSelected: notifier.setSelectedStatus,
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
                      Text('My Leave Requests', style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp)),
                      Gap(4.h),
                      Text(
                        'Total: ${state.filteredRequests.length} requests',
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                DigifyDivider(margin: EdgeInsets.symmetric(vertical: 20.h)),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: Column(
                    children: [
                      if (state.paginatedRequests.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Text(
                            'No leave requests match the current filters.',
                            style: context.textTheme.bodyMedium,
                          ),
                        )
                      else
                        for (var index = 0; index < state.paginatedRequests.length; index++) ...[
                          LeaveAbsenceRequestCard(
                            request: state.paginatedRequests[index],
                            onView: () {
                              ToastService.info(context, 'Viewing ${state.paginatedRequests[index].id}');
                            },
                            onDownload: () {
                              ToastService.info(
                                context,
                                'Download for ${state.paginatedRequests[index].id} is coming soon.',
                              );
                            },
                          ),
                          if (index != state.paginatedRequests.length - 1)
                            DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
                        ],
                      Gap(12.h),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
