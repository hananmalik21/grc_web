import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/domain/models/employee_leave_stats.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_stats_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveRequestEmployeeDetailLeaveStatsCards extends ConsumerWidget {
  const LeaveRequestEmployeeDetailLeaveStatsCards({
    super.key,
    required this.employeeGuid,
    required this.isDark,
    required this.localizations,
  });

  final String employeeGuid;
  final bool isDark;
  final AppLocalizations localizations;

  static const Color _iconBackgroundLight = AppColors.infoBg;
  static const Color _iconColor = AppColors.statIconBlue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(employeeLeaveStatsProvider(employeeGuid));

    return statsAsync.when(
      data: (stats) => _buildCardsRow(context, stats: stats),
      loading: () => Skeletonizer(enabled: true, child: _buildCardsRow(context)),
      error: (err, _) => _buildError(context, ref, err),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.somethingWentWrong,
              style: context.textTheme.bodySmall?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            TextButton(
              onPressed: () => ref.invalidate(employeeLeaveStatsProvider(employeeGuid)),
              child: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsRow(BuildContext context, {EmployeeLeaveStats? stats}) {
    final cards = [
      _LeaveRequestEmployeeDetailStatCard(
        label: localizations.totalRequests,
        value: stats?.totalDisplay ?? '0',
        iconPath: Assets.icons.leaveManagementMainIcon.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _LeaveRequestEmployeeDetailStatCard(
        label: localizations.leaveFilterApproved,
        value: stats?.approvedDisplay ?? '0',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _LeaveRequestEmployeeDetailStatCard(
        label: localizations.leaveFilterPending,
        value: stats?.pendingDisplay ?? '0',
        iconPath: Assets.icons.timeManagementMainIcon.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
      _LeaveRequestEmployeeDetailStatCard(
        label: localizations.rejected,
        value: stats?.rejectedDisplay ?? '0',
        iconPath: Assets.icons.leaveManagement.rejected.path,
        isDark: isDark,
        iconBgColor: _iconBackgroundLight,
        iconColor: _iconColor,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 21.w : 0),
              child: cards[i],
            ),
          ),
      ],
    );
  }
}

class _LeaveRequestEmployeeDetailStatCard extends StatelessWidget {
  const _LeaveRequestEmployeeDetailStatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.isDark,
    required this.iconBgColor,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String iconPath;
  final bool isDark;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(7.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 21, height: 21),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.capitalizeEachWord,
                  style: context.textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
                Gap(7.h),
                Text(
                  value,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
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
