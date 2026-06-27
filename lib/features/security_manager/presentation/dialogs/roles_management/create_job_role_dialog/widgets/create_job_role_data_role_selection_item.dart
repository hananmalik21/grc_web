import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/inherited_assignment_list_tile.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateJobRoleDataRoleSelectionItem extends StatelessWidget {
  const CreateJobRoleDataRoleSelectionItem({
    super.key,
    required this.role,
    required this.isSelected,
    required this.iconPath,
    this.onTap,
    this.isLocked = false,
  });

  final DataRoleItem role;
  final bool isSelected;
  final String iconPath;
  final VoidCallback? onTap;
  final bool isLocked;

  static const _maxScopeChips = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (isLocked) {
      return InheritedAssignmentListTile(
        title: role.name,
        below: _LockedDataRoleExtras(role: role),
      );
    }

    final scopeItems = [...role.orgUnits, ...role.positions];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg)
              : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.infoBorder : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CreateJobRoleSelectionCheckbox(isSelected: isSelected, onTap: null),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        role.name,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        role.code,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (iconPath.isNotEmpty)
                  DigifyAsset(
                    assetPath: Assets.icons.securityManager.dataRoles.path,
                    width: 18.w,
                    height: 18.w,
                    color: AppColors.primary,
                  ),
              ],
            ),
            if (role.dataType.isNotEmpty) ...[
              Gap(8.h),
              DigifySquareCapsule(
                label: role.dataType,
                backgroundColor: AppColors.infoBg,
                textColor: AppColors.primary,
                borderColor: AppColors.infoBorder,
              ),
            ],
            if (scopeItems.isNotEmpty) ...[Gap(8.h), _ScopeChips(scopeItems: scopeItems)],
          ],
        ),
      ),
    );
  }
}

class _LockedDataRoleExtras extends StatelessWidget {
  const _LockedDataRoleExtras({required this.role});

  final DataRoleItem role;

  @override
  Widget build(BuildContext context) {
    final scopeItems = [...role.orgUnits, ...role.positions];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (role.dataType.isNotEmpty) ...[
          Gap(8.h),
          DigifySquareCapsule(
            label: role.dataType,
            backgroundColor: AppColors.infoBg,
            textColor: AppColors.primary,
            borderColor: AppColors.infoBorder,
          ),
        ],
        if (scopeItems.isNotEmpty) ...[Gap(8.h), _ScopeChips(scopeItems: scopeItems)],
      ],
    );
  }
}

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({required this.scopeItems});

  final List<String> scopeItems;

  @override
  Widget build(BuildContext context) {
    final visible = scopeItems.take(CreateJobRoleDataRoleSelectionItem._maxScopeChips).toList();
    final remaining = scopeItems.length - visible.length;

    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        ...visible.map(
          (name) => Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(color: AppColors.cardBackgroundGrey, borderRadius: BorderRadius.circular(4.r)),
            child: Text(
              name,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ),
        ),
        if (remaining > 0)
          Text(
            '+$remaining more',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textTertiary),
          ),
      ],
    );
  }
}
