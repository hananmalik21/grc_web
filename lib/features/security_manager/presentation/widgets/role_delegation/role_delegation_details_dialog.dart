import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/core/utils/number_format_utils.dart';

class RoleDelegationDetailsDialog extends StatelessWidget {
  final RoleDelegationItem delegation;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onRevoke;

  const RoleDelegationDetailsDialog({
    super.key,
    required this.delegation,
    required this.onApprove,
    required this.onRevoke,
  });

  static Future<void> show(
    BuildContext context, {
    required RoleDelegationItem delegation,
    required ValueChanged<String> onApprove,
    required ValueChanged<String> onRevoke,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) =>
          RoleDelegationDetailsDialog(delegation: delegation, onApprove: onApprove, onRevoke: onRevoke),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final showApprove = delegation.status == RoleDelegationStatus.pendingApproval;
    final showRevoke =
        delegation.status != RoleDelegationStatus.revoked && delegation.status != RoleDelegationStatus.expired;

    return AppDialog(
      title: 'Delegation Details',
      subtitle: 'Complete delegation information',
      width: 648.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopSummaryCard(isDark: isDark, delegation: delegation),
          Gap(20.h),
          _SectionHeading(title: 'Delegation Flow'),
          Gap(10.h),
          _InfoCard(
            isDark: isDark,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _UserFlowBlock(label: 'Delegator', user: delegation.delegator),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: DigifyAsset(
                    assetPath: Assets.icons.enterpriseStructure.rightArrow.path,
                    width: 24,
                    height: 24,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: _UserFlowBlock(label: 'Delegate', user: delegation.delegatee),
                ),
              ],
            ),
          ),
          Gap(20.h),
          _SectionHeading(title: 'Delegated Roles'),
          Gap(10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final role in delegation.delegatedRoles)
                DigifySquareCapsule(
                  label: role,
                  backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.jobRoleBg,
                  borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
                  textColor: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                  borderRadius: BorderRadius.circular(7.r),
                ),
            ],
          ),
          Gap(20.h),
          _SectionHeading(title: 'Timeline'),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  isDark: isDark,
                  child: _TimelineTile(
                    iconPath: Assets.icons.leaveManagement.emptyLeave.path,
                    label: 'Start Date',
                    value: DateTimeUtils.formatYmd(delegation.startDate),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _InfoCard(
                  isDark: isDark,
                  child: _TimelineTile(
                    iconPath: Assets.icons.leaveManagement.emptyLeave.path,
                    label: 'End Date',
                    value: DateTimeUtils.formatYmd(delegation.endDate),
                  ),
                ),
              ),
            ],
          ),
          Gap(20.h),
          _SectionHeading(title: 'Delegation Reason'),
          Gap(10.h),
          _InfoCard(
            isDark: isDark,
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.infoCircleBlue.path,
                  width: 17,
                  height: 17,
                  color: AppColors.primaryLight,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    delegation.reason,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontSize: 16.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', height: 40.h, onPressed: () => Navigator.of(context).pop()),
        if (showApprove) ...[
          Gap(10.w),
          AppButton(
            label: 'Approve Delegation',
            onPressed: () => _confirmApprove(context),
            type: AppButtonType.outline,
            svgPath: Assets.icons.checkIconGreen.path,
            svgAssetColor: AppColors.buttonTextLight,
            foregroundColor: AppColors.buttonTextLight,
            backgroundColor: AppColors.primary,
            borderColor: AppColors.primary,
            height: 38.h,
            fontSize: 13.sp,
            iconSize: 15,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ],
        if (showRevoke) ...[
          Gap(10.w),
          AppButton(
            label: 'Revoke Delegation',
            onPressed: () => _confirmRevoke(context),
            type: AppButtonType.outline,
            svgPath: Assets.icons.leaveManagement.rejected.path,
            svgAssetColor: AppColors.buttonTextLight,
            foregroundColor: AppColors.buttonTextLight,
            backgroundColor: AppColors.redButton,
            borderColor: AppColors.redButton,
            height: 38.h,
            fontSize: 13.sp,
            iconSize: 15,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmApprove(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Approve Delegation',
      message: 'Are you sure you want to approve this delegation?',
      itemName: '${delegation.delegator.name} → ${delegation.delegatee.name}',
      confirmLabel: 'Approve',
      type: ConfirmationType.success,
      svgPath: Assets.icons.checkIconGreen.path,
    );

    if (confirmed != true || !context.mounted) return;
    onApprove(delegation.id);
    Navigator.of(context).pop();
  }

  Future<void> _confirmRevoke(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Revoke Delegation',
      message: 'Are you sure you want to revoke this delegation?',
      itemName: '${delegation.delegator.name} → ${delegation.delegatee.name}',
      confirmLabel: 'Revoke',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true || !context.mounted) return;
    onRevoke(delegation.id);
    Navigator.of(context).pop();
  }
}

class _TopSummaryCard extends StatelessWidget {
  final bool isDark;
  final RoleDelegationItem delegation;

  const _TopSummaryCard({required this.isDark, required this.delegation});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      isDark: isDark,
      padding: EdgeInsets.all(13.5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MinorLabel(text: 'Status'),
              Gap(6.h),
              DigifySquareCapsule(
                label: delegation.status.label,
                backgroundColor: delegation.status.capsuleBackgroundColor(isDark: isDark),
                borderColor: delegation.status.capsuleBorderColor(isDark: isDark),
                textColor: delegation.status.capsuleTextColor(isDark: isDark),
                borderRadius: BorderRadius.circular(7.r),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _MinorLabel(text: 'Delegation ID'),
              Gap(7.h),
              Text(
                delegation.id,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserFlowBlock extends StatelessWidget {
  final String label;
  final RoleDelegationUser user;

  const _UserFlowBlock({required this.label, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MinorLabel(text: label),
        Gap(7.h),
        Row(
          children: [
            AppAvatar(fallbackInitial: user.name, size: 40.5.w, backgroundColor: AppColors.primary),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    user.title,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String iconPath;
  final String label;
  final Object value;

  const _TimelineTile({required this.iconPath, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(
              assetPath: iconPath,
              width: 14,
              height: 14,
              color: isDark ? AppColors.textMutedDark : AppColors.primary,
            ),
            Gap(6.w),
            _MinorLabel(text: label),
          ],
        ),
        Gap(6.h),
        Text(
          NumberFormatUtils.formatDisplayValue(value),
          style: context.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      title,
      style: context.textTheme.labelLarge?.copyWith(
        fontSize: 14.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.inactiveStatusText,
      ),
    );
  }
}

class _MinorLabel extends StatelessWidget {
  final String text;

  const _MinorLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        fontSize: 12.sp,
        color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _InfoCard({required this.isDark, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(13.5.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }
}
