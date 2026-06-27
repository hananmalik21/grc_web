import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_surface_card.dart';

class RolesManagementRoleSelectorSection extends StatelessWidget {
  const RolesManagementRoleSelectorSection({
    super.key,
    required this.roles,
    required this.selectedRoleId,
    required this.onRoleSelected,
  });

  final List<RoleModel> roles;
  final String? selectedRoleId;
  final ValueChanged<String> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSectionCard(
      title: 'Available Roles',
      subtitle: '${roles.length} matching roles',
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: roles
            .map(
              (role) => _RoleSelectorTile(
                role: role,
                isSelected: role.id == selectedRoleId,
                onTap: () => onRoleSelected(role.id),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RoleSelectorTile extends StatelessWidget {
  const _RoleSelectorTile({required this.role, required this.isSelected, required this.onTap});

  final RoleModel role;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: context.isMobile ? double.infinity : 260.w,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg)
              : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.infoBorderDark
                : (isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    role.name,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected) Icon(Icons.check_circle_rounded, size: 18.sp, color: AppColors.primary),
              ],
            ),
            Gap(6.h),
            Text(
              role.code,
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            Gap(8.h),
            Text(
              role.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            Gap(12.h),
            Row(
              children: [
                DigifySquareCapsule(
                  label: role.type.label,
                  backgroundColor: AppColors.infoBg,
                  borderColor: AppColors.infoBorder,
                  textColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(7.r),
                ),
                const Spacer(),
                Text(
                  '${role.usersAssigned} users',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
