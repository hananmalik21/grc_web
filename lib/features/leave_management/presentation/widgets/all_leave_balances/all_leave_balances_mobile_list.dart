import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/number_format_utils.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/mixins/leave_balances_list_logic_mixin.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/all_leave_balances_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_badge.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllLeaveBalancesMobileList extends ConsumerWidget with LeaveBalancesListLogicMixin {
  const AllLeaveBalancesMobileList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final listState = ref.watch(leaveBalanceSummaryListProvider);

    if (listState.isLoading && listState.items.isEmpty) {
      return _buildSkeleton(isDark);
    }

    if (listState.error != null && listState.items.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        iconBackground: AppColors.errorBg,
        iconPath: Assets.icons.warningIcon.path,
        iconColor: AppColors.error,
        title: 'Unable to Load Balances',
        subtitle: localizations.somethingWentWrong,
      );
    }

    if (listState.items.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        iconBackground: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        iconPath: Assets.icons.leaveManagement.emptyLeave.path,
        title: localizations.noResultsFound,
        subtitle: 'No leave balance records match the current search',
      );
    }

    final onPreviousPage = listState.pagination?.hasPrevious == true
        ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage - 1)
        : null;
    final onNextPage = listState.pagination?.hasNext == true
        ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage + 1)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeletonizer(
          enabled: listState.isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listState.items.length,
            separatorBuilder: (_, _) => Gap(10.h),
            itemBuilder: (context, index) =>
                _LeaveBalanceMobileCard(item: listState.items[index], localizations: localizations, isDark: isDark),
          ),
        ),
        if (listState.pagination != null) ...[
          Gap(12.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: listState.pagination!,
            currentPage: listState.currentPage,
            pageSize: listState.pagination!.pageSize,
            onPrevious: onPreviousPage,
            onNext: onNextPage,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ],
    );
  }

  Widget _buildSkeleton(bool isDark) {
    final placeholder = LeaveBalanceSummaryItem.skeletonPlaceholder();
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (context, _) =>
            _LeaveBalanceMobileCard(item: placeholder, localizations: AppLocalizations.of(context)!, isDark: isDark),
      ),
    );
  }
}

class _LeaveBalanceMobileCard extends StatelessWidget
    with AllLeaveBalancesPermissionMixin, LeaveBalancesListLogicMixin {
  const _LeaveBalanceMobileCard({required this.item, required this.localizations, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(item: item, isDark: isDark),
          const DigifyDivider(),
          _CardBody(item: item, localizations: localizations, isDark: isDark),
          const DigifyDivider(),
          _CardFooter(item: item, localizations: localizations, isDark: isDark),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.item, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final nameStyle = context.textTheme.titleSmall?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    );
    final subtitleStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      fontSize: 11.sp,
    );
    final deptColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final deptBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.employeeName.trim().isEmpty ? '-' : item.employeeName,
                  style: nameStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(2.h),
                Text(item.employeeNumber.isEmpty ? '-' : item.employeeNumber, style: subtitleStyle),
              ],
            ),
          ),
          if (item.department.isNotEmpty) ...[
            Gap(8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(color: deptBg, borderRadius: BorderRadius.circular(100.r)),
              child: Text(
                item.department,
                style: context.textTheme.labelSmall?.copyWith(color: deptColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardBody extends StatelessWidget with LeaveBalancesListLogicMixin {
  const _CardBody({required this.item, required this.localizations, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      fontSize: 11.sp,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _BalanceTile(
                  label: localizations.annualLeave,
                  labelStyle: labelStyle,
                  child: LeaveBalanceBadge(
                    text: formatBalanceDays(item.annualLeave, localizations),
                    type: LeaveBadgeType.annualLeave,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _BalanceTile(
                  label: localizations.sickLeave,
                  labelStyle: labelStyle,
                  child: LeaveBalanceBadge(
                    text: formatBalanceDays(item.sickLeave, localizations),
                    type: LeaveBadgeType.sickLeave,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _BalanceTile(
                  label: 'Unpaid Leave',
                  labelStyle: labelStyle,
                  child: LeaveBalanceBadge(
                    text: '${NumberFormatUtils.formatDays(0)} ${localizations.days.toLowerCase()}',
                    type: LeaveBadgeType.unpaidLeave,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _BalanceTile(
                  label: 'Total Available',
                  labelStyle: labelStyle,
                  child: LeaveBalanceBadge(
                    text: formatBalanceDays(item.totalAvailable, localizations),
                    type: LeaveBadgeType.totalAvailable,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget with AllLeaveBalancesPermissionMixin, LeaveBalancesListLogicMixin {
  const _CardFooter({required this.item, required this.localizations, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final joinStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      fontSize: 11.sp,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          if (item.joinDate != null)
            Expanded(
              child: Text(
                'Joined ${formatJoinDate(item.joinDate)}',
                style: joinStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canViewLeaveBalance) ...[
                AppMobileButton.primary(
                  svgPath: Assets.icons.viewIconBlue.path,
                  onPressed: () => openDetails(context, item),
                ),
              ],
              if (canUpdateLeaveBalance) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor: AppColors.editIconGreen,
                  onPressed: () => openAdjust(context, item),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.label, required this.labelStyle, required this.child});

  final String label;
  final TextStyle? labelStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Gap(4.h),
        child,
      ],
    );
  }
}
