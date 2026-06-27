import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/utils/date_time_utils.dart';

class RoleDelegationDelegationsSection extends StatefulWidget {
  final bool isDark;
  final List<RoleDelegationItem> delegations;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final VoidCallback? onViewAll;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onRevoke;
  final ValueChanged<String> onDetails;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const RoleDelegationDelegationsSection({
    super.key,
    required this.isDark,
    required this.delegations,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onApprove,
    required this.onRevoke,
    required this.onDetails,
    this.onPrevious,
    this.onNext,
    this.onViewAll,
  });

  @override
  State<RoleDelegationDelegationsSection> createState() => _RoleDelegationDelegationsSectionState();
}

class _RoleDelegationDelegationsSectionState extends State<RoleDelegationDelegationsSection> {
  late final ScrollController _cardsScrollController;

  @override
  void initState() {
    super.initState();
    _cardsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _cardsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsViewportHeight = 580.h;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 620.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Active Delegations', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              if (widget.onViewAll != null)
                TextButton(
                  onPressed: widget.onViewAll,
                  child: Text('View all', style: context.textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
                ),
            ],
          ),
          SizedBox(
            height: cardsViewportHeight,
            child: widget.delegations.isEmpty
                ? Center(
                    child: Text(
                      'No delegations found.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  )
                : Scrollbar(
                    controller: _cardsScrollController,
                    child: SingleChildScrollView(
                      controller: _cardsScrollController,
                      child: Column(
                        spacing: 12.h,
                        children: [
                          for (final delegation in widget.delegations)
                            _RoleDelegationCard(
                              isDark: widget.isDark,
                              delegation: delegation,
                              onApprove: widget.onApprove,
                              onRevoke: widget.onRevoke,
                              onDetails: () => widget.onDetails(delegation.id),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
          PaginationControls(
            currentPage: widget.currentPage,
            totalPages: widget.totalItems == 0 ? 1 : (widget.totalItems / widget.pageSize).ceil(),
            totalItems: widget.totalItems,
            pageSize: widget.pageSize,
            hasNext: widget.onNext != null,
            hasPrevious: widget.onPrevious != null,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
            style: PaginationStyle.simple,
            showBorder: false,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _RoleDelegationCard extends StatelessWidget {
  final bool isDark;
  final RoleDelegationItem delegation;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onRevoke;
  final VoidCallback onDetails;

  const _RoleDelegationCard({
    required this.isDark,
    required this.delegation,
    required this.onApprove,
    required this.onRevoke,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ActionButton.details(onPressed: onDetails),
      if (delegation.status == RoleDelegationStatus.pendingApproval)
        _ActionButton.approve(onPressed: () => _confirmApprove(context)),
      if (delegation.status != RoleDelegationStatus.revoked && delegation.status != RoleDelegationStatus.expired)
        _ActionButton.revoke(onPressed: () => _confirmRevoke(context)),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifySquareCapsule(
                      label: delegation.status.label,
                      backgroundColor: delegation.status.capsuleBackgroundColor(isDark: isDark),
                      borderColor: delegation.status.capsuleBorderColor(isDark: isDark),
                      textColor: delegation.status.capsuleTextColor(isDark: isDark),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    Gap(10.w),
                    Text(
                      'ID: ${delegation.id}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Gap(14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _UserBlock(isDark: isDark, label: 'Delegator', user: delegation.delegator),
                    ),
                    Gap(18.w),
                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: DigifyAsset(
                        assetPath: Assets.icons.enterpriseStructure.rightArrow.path,
                        width: 20,
                        height: 20,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: _UserBlock(isDark: isDark, label: 'Delegate', user: delegation.delegatee),
                    ),
                  ],
                ),
                Gap(14.h),
                Text(
                  'Delegated Roles',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(7.h),
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
                Gap(14.h),
                Row(
                  children: [
                    Expanded(
                      child: _MetaItem(
                        isDark: isDark,
                        iconPath: Assets.icons.employeesAssignedIcon.path,
                        label: 'Start Date',
                        value: DateTimeUtils.formatYmd(delegation.startDate),
                      ),
                    ),
                    Gap(18.w),
                    Expanded(
                      child: _MetaItem(
                        isDark: isDark,
                        iconPath: Assets.icons.employeesAssignedIcon.path,
                        label: 'End Date',
                        value: DateTimeUtils.formatYmd(delegation.endDate),
                      ),
                    ),
                    Gap(18.w),
                    Expanded(
                      child: _MetaItem(
                        isDark: isDark,
                        iconPath: Assets.icons.infoCircleBlue.path,
                        label: 'Reason',
                        value: delegation.reason,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(14.w),
          Column(
            children: [
              for (final button in buttons) ...[
                SizedBox(width: 100.w, child: button),
                if (button != buttons.last) Gap(8.h),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmApprove(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Approve Delegation',
      message: 'Are you sure you want to approve this delegation?',
      itemName: _dialogItemName(),
      confirmLabel: 'Approve',
      type: ConfirmationType.success,
      svgPath: Assets.icons.checkIconGreen.path,
    );

    if (confirmed != true) return;
    onApprove(delegation.id);
  }

  Future<void> _confirmRevoke(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Revoke Delegation',
      message: 'Are you sure you want to revoke this delegation?',
      itemName: _dialogItemName(),
      confirmLabel: 'Revoke',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;
    onRevoke(delegation.id);
  }

  String _dialogItemName() {
    return '${delegation.delegator.name} → ${delegation.delegatee.name}';
  }
}

class _MetaItem extends StatelessWidget {
  final bool isDark;
  final String iconPath;
  final String label;
  final String value;

  const _MetaItem({required this.isDark, required this.iconPath, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.h,
      children: [
        Row(
          children: [
            DigifyAsset(
              assetPath: iconPath,
              width: 14,
              height: 14,
              color: isDark ? AppColors.textMutedDark : AppColors.grayBorderDark,
            ),
            Gap(6.w),
            Text(
              label,
              style: context.textTheme.headlineMedium?.copyWith(
                color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _UserBlock extends StatelessWidget {
  final bool isDark;
  final String label;
  final RoleDelegationUser user;

  const _UserBlock({required this.isDark, required this.label, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.headlineMedium?.copyWith(
            color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
            fontSize: 14.sp,
          ),
        ),
        Gap(4.h),
        Row(
          children: [
            AppAvatar(fallbackInitial: user.name, size: 27.w, backgroundColor: AppColors.primary),
            Gap(7.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
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

class _ActionButton extends StatelessWidget {
  final AppButton button;

  const _ActionButton._(this.button);

  factory _ActionButton.details({required VoidCallback onPressed}) {
    return _ActionButton._(
      AppButton(
        label: 'Details',
        onPressed: onPressed,
        type: AppButtonType.outline,
        svgPath: Assets.icons.eyesIcon.path,
        svgAssetColor: AppColors.delegationDetailsText,
        foregroundColor: AppColors.delegationDetailsText,
        backgroundColor: AppColors.delegationDetailsBg,
        borderColor: AppColors.delegationDetailsBorder,
        height: 30.h,
        fontSize: 12.sp,
        iconSize: 14,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        borderRadius: BorderRadius.circular(7.r),
      ),
    );
  }

  factory _ActionButton.approve({required VoidCallback onPressed}) {
    return _ActionButton._(
      AppButton(
        label: 'Approve',
        onPressed: onPressed,
        type: AppButtonType.outline,
        svgPath: Assets.icons.checkIconGreen.path,
        svgAssetColor: AppColors.delegationApproveText,
        foregroundColor: AppColors.delegationApproveText,
        backgroundColor: AppColors.delegationApproveBg,
        borderColor: AppColors.delegationApproveBorder,
        height: 30.h,
        fontSize: 12.sp,
        iconSize: 14,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        borderRadius: BorderRadius.circular(7.r),
      ),
    );
  }

  factory _ActionButton.revoke({required VoidCallback onPressed}) {
    return _ActionButton._(
      AppButton(
        label: 'Revoke',
        onPressed: onPressed,
        type: AppButtonType.outline,
        svgPath: Assets.icons.leaveManagement.rejected.path,
        svgAssetColor: AppColors.delegationRevokeText,
        foregroundColor: AppColors.delegationRevokeText,
        backgroundColor: AppColors.delegationRevokeBg,
        borderColor: AppColors.delegationRevokeBorder,
        height: 30.h,
        fontSize: 12.sp,
        iconSize: 14,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        borderRadius: BorderRadius.circular(7.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => button;
}
