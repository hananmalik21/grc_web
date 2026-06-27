import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_list_provider.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/person_result_detail_page.dart';
// import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_table_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonResultsListMobile extends ConsumerWidget {
  const PersonResultsListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final employees = ref.watch(personResultsPaginatedEmployeesProvider);
    final currentPage = ref.watch(personResultsUiProvider.select((state) => state.currentPage));
    final totalPages = ref.watch(personResultsTotalPagesProvider);
    final hasNext = ref.watch(personResultsHasNextProvider);
    final hasPrevious = ref.watch(personResultsHasPreviousProvider);
    final uiNotifier = ref.read(personResultsUiProvider.notifier);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar disabled for now — re-enable when filter/sort in-table controls are needed.
          // const PersonResultsTableToolbar(),
          if (employees.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                icon: Icon(
                  Icons.people_alt_rounded,
                  size: 32.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                title: loc.payrollPersonResultsNoEmployeesFound,
                subtitle: loc.payrollPersonResultsNoEmployeesMessage,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
              itemCount: employees.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => _PersonResultCard(employee: employees[index], isDark: isDark),
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

class _PersonResultCard extends StatelessWidget {
  const _PersonResultCard({required this.employee, required this.isDark});

  final PersonResultEmployee employee;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final status = employee.isActive ? loc.active : loc.inactive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(PersonResultDetailPage.routeName, extra: employee),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
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
                  AppAvatar(fallbackInitial: employee.name, size: 36.w),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(2.h),
                        Text(
                          employee.businessTitle,
                          style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  DigifyStatusCapsule(status: status),
                ],
              ),
              Gap(12.h),
              _InfoLine(
                label: loc.payrollPersonResultsPersonNumber,
                value: employee.personNumber,
                color: subtitleColor,
              ),
              Gap(8.h),
              _InfoLine(
                label: loc.payrollPersonResultsAssignmentNumber,
                value: employee.assignmentNumber,
                color: subtitleColor,
              ),
              Gap(8.h),
              _InfoLine(label: loc.payrollPersonResultsWorkerType, value: employee.workerType, color: subtitleColor),
              Gap(8.h),
              _InfoLine(label: loc.payrollPersonResultsWorkEmail, value: employee.workEmail, color: subtitleColor),
              Gap(8.h),
              _InfoLine(label: loc.payrollPersonResultsWorkPhone, value: employee.workPhone, color: subtitleColor),
            ],
          ),
        ),
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
