import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../dialogs/access_management/role_form_dialog.dart';
import '../../providers/access_management/access_management_provider.dart';
import 'access_section_card.dart';

class AccessRoleList extends ConsumerWidget {
  const AccessRoleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessManagementProvider);
    final notifier = ref.read(accessManagementProvider.notifier);
    return AccessSectionCard(
      title: 'Roles',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 500.h),
        child: Column(
          children: [
            ListView.separated(
              itemBuilder: (context, index) => RoleTile(
                role: state.roles[index],
                onTap: () => notifier.selectRole(state.roles[index]),
                isSelected: state.selectedRole == state.roles[index],
              ),
              separatorBuilder: (context, index) => Gap(16.h),
              itemCount: state.roles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            Gap(24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => RoleFormDialog.show(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Role',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleTile extends ConsumerWidget {
  const RoleTile({
    super.key,
    required this.role,
    this.isSelected = false,
    this.onTap,
  });

  final AccessRole role;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleColor = context.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final subtitleColor = context.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    // Map role type to colors
    final typeColor = role.type == 'Admin'
        ? AppColors.infoBg
        : (role.type == 'Manager'
              ? const Color(0xFFE3F2FD)
              : const Color(0xFFE8EAF6));
    final typeTextColor = AppColors.statIconBlue;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: .1) : null,
          border: Border.all(
            color: isSelected ? AppColors.primary : context.themeCardBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    role.name,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : titleColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    role.type,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: typeTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              role.description,
              style: context.textTheme.bodySmall?.copyWith(
                color: subtitleColor,
              ),
            ),
            Gap(8.h),
            Text(
              '${role.assignedUsersCount} users assigned',
              style: context.textTheme.bodySmall?.copyWith(
                color: subtitleColor,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
