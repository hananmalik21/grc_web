import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/security_alerts/security_alerts_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityAlertsActivityCard extends StatelessWidget {
  final SecurityAlertItem alert;
  final bool isDark;

  const SecurityAlertsActivityCard({super.key, required this.alert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: alert.level.capsuleBackgroundColor(isDark: isDark),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DigifyAsset(
            assetPath: alert.iconPath,
            width: 20,
            height: 20,
            color: alert.level.capsuleTextColor(isDark: isDark),
          ),
        ),
        Gap(14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    alert.issueType.label,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 16.sp,
                    ),
                  ),
                  Gap(10.w),
                  Flexible(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      alignment: WrapAlignment.end,
                      children: [
                        DigifySquareCapsule(
                          label: alert.level.label,
                          backgroundColor: alert.level.capsuleBackgroundColor(isDark: isDark),
                          borderColor: alert.level.capsuleBorderColor(isDark: isDark),
                          textColor: alert.level.capsuleTextColor(isDark: isDark),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        DigifySquareCapsule(
                          label: alert.alertId,
                          backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                          borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        if (alert.status.label != alert.level.label) _StatusPill(alert: alert, isDark: isDark),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(7.h),
              Text(
                alert.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(12.h),
              Wrap(
                spacing: 18.w,
                runSpacing: 10.h,
                children: [
                  _MetaInfoItem(
                    iconPath: Assets.icons.leaveManagement.shield.path,
                    label: 'Alert ID:',
                    value: alert.alertId,
                  ),
                  _MetaInfoItem(iconPath: Assets.icons.userIcon.path, label: 'User:', value: 'Unknown'),
                  _MetaInfoItem(
                    iconPath: Assets.icons.clockIcon.path,
                    label: 'Time:',
                    value: '${alert.lastUpdated}:00',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final actions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < alert.actions.length; i++) ...[
          SizedBox(
            width: 140.w,
            child: _AlertActionButton(action: alert.actions[i], isDark: isDark),
          ),
          if (i < alert.actions.length - 1) Gap(8.h),
        ],
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.tableHeaderBackground : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.2),
      ),
      child: compact
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [content, Gap(16.h), actions])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: content),
                Gap(16.w),
                actions,
              ],
            ),
    );
  }
}

class _AlertActionButton extends StatelessWidget {
  final SecurityAlertAction action;
  final bool isDark;

  const _AlertActionButton({required this.action, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor, borderColor) = switch (action) {
      SecurityAlertAction.view => (
        isDark ? AppColors.infoBgDark : AppColors.infoBg,
        AppColors.primary,
        isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
      ),
      SecurityAlertAction.acknowledge => (
        isDark ? AppColors.successBgDark : AppColors.successBg,
        AppColors.success,
        isDark ? AppColors.successBorderDark : AppColors.successBorder,
      ),
      SecurityAlertAction.dismiss => (
        isDark ? AppColors.tableHeaderBackground : AppColors.securityProfilesBackground,
        AppColors.textSecondary,
        isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
      ),
      SecurityAlertAction.resolve => (
        isDark ? AppColors.successBgDark : AppColors.greenBg,
        AppColors.success,
        isDark ? AppColors.successBorderDark : AppColors.greenBorder,
      ),
    };

    return AppButton(
      label: action.label,
      type: AppButtonType.outline,
      svgPath: action.iconPath,
      height: 30.h,
      fontSize: 12.sp,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      onPressed: () async {
        if (action == SecurityAlertAction.view) return;

        final confirmed = await AppConfirmationDialog.show(
          context,
          title: action == SecurityAlertAction.resolve ? 'Resolve Alert' : 'Dismiss Alert',
          message: action == SecurityAlertAction.resolve
              ? 'Are you sure you want to resolve this alert?'
              : 'Are you sure you want to dismiss this alert?',
          confirmLabel: action == SecurityAlertAction.resolve ? 'Resolve' : 'Dismiss',
          type: action == SecurityAlertAction.resolve ? ConfirmationType.success : ConfirmationType.warning,
          svgPath: action == SecurityAlertAction.resolve
              ? Assets.icons.checkIconGreen.path
              : Assets.icons.leaveManagement.rejected.path,
        );

        if (confirmed != true) return;
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  final SecurityAlertItem alert;
  final bool isDark;

  const _StatusPill({required this.alert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, borderColor, foregroundColor) = switch (alert.status) {
      SecurityAlertStatus.newAlert => (
        isDark ? AppColors.warningBgDark : AppColors.warningBg,
        isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        AppColors.warning,
      ),
      SecurityAlertStatus.resolved => (
        isDark ? AppColors.successBgDark : AppColors.successBg,
        isDark ? AppColors.successBorderDark : AppColors.successBorder,
        AppColors.success,
      ),
      SecurityAlertStatus.acknowledged => (
        isDark ? AppColors.infoBgDark : AppColors.infoBg,
        isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        AppColors.primary,
      ),
      SecurityAlertStatus.all => (
        isDark ? AppColors.grayBgDark : AppColors.grayBg,
        isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        isDark ? AppColors.grayTextDark : AppColors.grayText,
      ),
    };

    return DigifySquareCapsule(
      label: alert.status.label,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      textColor: foregroundColor,
      borderRadius: BorderRadius.circular(7.r),
    );
  }
}

class _MetaInfoItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _MetaInfoItem({required this.iconPath, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 7.w,
      children: [
        DigifyAsset(assetPath: iconPath, width: 14, height: 14, color: AppColors.textSecondary),
        Text(label, style: context.textTheme.labelMedium?.copyWith(color: AppColors.textPrimary)),
        Text(
          value,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: context.isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark,
          ),
        ),
      ],
    );
  }
}
