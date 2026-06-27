import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/compensation/presentation/models/compensation_plan_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/compensation_plan_detail_screen.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/edit_compensation_plan_mobile_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/compensation_plans_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CompensationPlansListMobile extends ConsumerWidget {
  const CompensationPlansListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final liveRows = ref.watch(compensationPlansPagedRowsProvider);
    final isLoading = ref.watch(compensationPlansTableIsLoadingProvider);
    final errorMessage = ref.watch(compensationPlansTableErrorProvider);
    final skeletonRows = ref.watch(compensationPlansSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(compensationPlansCurrentPageProvider);
    final totalPages = ref.watch(compensationPlansTotalPagesProvider);
    ref.watch(compensationPlansTotalItemsProvider);
    final hasNext = ref.watch(compensationPlansHasNextProvider);
    final hasPrevious = ref.watch(compensationPlansHasPreviousProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null && liveRows.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: 'Failed to load compensation plans',
                subtitle: errorMessage,
                action: GestureDetector(
                  onTap: () => ref.invalidate(compensationPlansPageProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                    ),
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: isLoading,
              child: rows.isEmpty && !isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: MobileStateCard(
                        isDark: isDark,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                        icon: Icon(
                          Icons.list_alt_rounded,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: 'No Plans Found',
                        subtitle: 'No compensation plans match your search or filters.',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) => _PlanCard(row: rows[index], isDark: isDark),
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(compensationPlansCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(compensationPlansCurrentPageProvider.notifier).state = currentPage + 1
                : null,
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.row, required this.isDark});

  final CompensationPlanTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingPlanGuid = ref.watch(compensationPlansDeletionControllerProvider);
    final isDeleting = deletingPlanGuid == row.planGuid;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
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
                child: Text(
                  row.name,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(8.h),
          Row(
            children: [
              DigifySquareCapsule(
                label: row.code,
                backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                textColor: subtitleColor,
                borderColor: tileBorderColor,
              ),
              Gap(6.w),
              DigifyCapsule(
                label: row.type,
                textColor: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
              Gap(6.w),
              Text(
                row.currency,
                style: context.textTheme.labelMedium?.copyWith(color: subtitleColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Align(
            alignment: Alignment.centerRight,
            child: _ActionButtons(row: row, isDeleting: isDeleting),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget with CompensationPlansPermissionMixin {
  const _ActionButtons({required this.row, required this.isDeleting});

  final CompensationPlanTableRowData row;
  final bool isDeleting;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final result = await AppConfirmationDialog.show(
      context,
      title: 'Delete Compensation Plan',
      message: 'Are you sure you want to delete this compensation plan?',
      itemName: row.name,
      confirmLabel: 'Delete',
      type: ConfirmationType.danger,
    );

    if (result == true && context.mounted) {
      try {
        await ref
            .read(compensationPlansDeletionControllerProvider.notifier)
            .deleteCompensationPlan(planGuid: row.planGuid);

        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Compensation plan deleted successfully',
            type: ToastType.success,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Failed to delete compensation plan: ${e.toString()}',
            type: ToastType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canViewCompensationPlan)
          Tooltip(
            message: 'View',
            child: AppMobileButton(
              svgPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.viewIconBlue.withValues(alpha: 0.1),
              foregroundColor: AppColors.viewIconBlue,
              onPressed: isDeleting
                  ? null
                  : () => context.pushNamed(CompensationPlanDetailScreen.routeName, extra: row),
            ),
          ),
        if (canUpdateCompensationPlan) ...[
          Gap(6.w),
          Tooltip(
            message: 'Edit',
            child: AppMobileButton(
              svgPath: Assets.icons.editIcon.path,
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
              foregroundColor: AppColors.success,
              onPressed: isDeleting
                  ? null
                  : () async {
                      final edited = await EditCompensationPlanMobileSheet.show(context, planGuid: row.planGuid);
                      if (edited && context.mounted) {
                        ref.invalidate(compensationPlansPageProvider);
                      }
                    },
            ),
          ),
        ],
        if (canDeleteCompensationPlan) ...[
          Gap(6.w),
          Tooltip(
            message: 'Delete',
            child: AppMobileButton.danger(
              svgPath: Assets.icons.deleteIconRed.path,
              isLoading: isDeleting,
              onPressed: () => _confirmDelete(context, ref),
            ),
          ),
        ],
      ],
    );
  }
}
