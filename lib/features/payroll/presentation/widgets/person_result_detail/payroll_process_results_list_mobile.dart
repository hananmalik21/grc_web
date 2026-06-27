import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_tasks_provider.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/models/person_result_task_detail_args.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/person_result_task_detail_page.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PayrollProcessResultsListMobile extends ConsumerWidget {
  const PayrollProcessResultsListMobile({required this.employee, super.key});

  final PersonResultEmployee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final personNumber = employee.personNumber;
    final tasks = ref.watch(personResultDetailPaginatedTasksProvider(personNumber));
    final currentPage = ref.watch(personResultDetailUiProvider.select((state) => state.currentPage));
    final totalPages = ref.watch(personResultDetailTotalPagesProvider(personNumber));
    final hasNext = ref.watch(personResultDetailHasNextProvider(personNumber));
    final hasPrevious = ref.watch(personResultDetailHasPreviousProvider(personNumber));
    final uiNotifier = ref.read(personResultDetailUiProvider.notifier);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PayrollProcessResultsSectionHeader(personNumber: personNumber),
          if (tasks.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                icon: Icon(
                  Icons.task_alt_rounded,
                  size: 32.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                title: loc.payrollPersonResultsNoTasksFound,
                subtitle: loc.payrollPersonResultsNoTasksMessage,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
              itemCount: tasks.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => _TaskCard(employee: employee, task: tasks[index], isDark: isDark),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: hasPrevious ? () => uiNotifier.setCurrentPage(currentPage - 1) : null,
            onNext: hasNext ? () => uiNotifier.setCurrentPage(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.employee, required this.task, required this.isDark});

  final PersonResultEmployee employee;
  final PayrollProcessResultTask task;
  final bool isDark;

  void _openTaskDetail(BuildContext context) {
    context.pushNamed(
      PersonResultTaskDetailPage.routeName,
      extra: PersonResultTaskDetailArgs(employee: employee, task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final statusLabel = task.statusLabel(
      completeLabel: loc.payrollPersonResultsTaskStatusComplete,
      inProgressLabel: loc.payrollPersonResultsTaskStatusInProgress,
    );

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _openTaskDetail(context),
                    child: Text(
                      task.taskName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: statusLabel),
            ],
          ),
          Gap(12.h),
          _InfoLine(label: loc.payrollPersonResultsFlowName, value: task.flowName, color: subtitleColor),
          Gap(8.h),
          _InfoLine(label: loc.payrollPersonResultsProcessDate, value: task.processDate, color: subtitleColor),
          Gap(8.h),
          _InfoLine(label: loc.payrollPersonResultsPayrollColumn, value: task.payroll, color: subtitleColor),
          Gap(8.h),
          _InfoLine(label: loc.payrollPersonResultsPayrollPeriod, value: task.payrollPeriod, color: subtitleColor),
          Gap(8.h),
          _InfoLine(label: loc.amount, value: task.amount, color: subtitleColor),
          Gap(12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ActionButtonWidget(
              type: ActionButtonType.view,
              onTap: () => _openTaskDetail(context),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: color),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
