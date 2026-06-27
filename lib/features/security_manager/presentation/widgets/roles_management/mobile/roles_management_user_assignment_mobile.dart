import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../roles_management_common_widgets.dart';
import '../roles_management_surface_card.dart';

class RolesManagementUserAssignmentMobile extends StatefulWidget {
  const RolesManagementUserAssignmentMobile({super.key, required this.users});

  final List<RoleAssignedUser> users;

  @override
  State<RolesManagementUserAssignmentMobile> createState() => _RolesManagementUserAssignmentMobileState();
}

class _RolesManagementUserAssignmentMobileState extends State<RolesManagementUserAssignmentMobile> {
  late final TextEditingController _searchController;
  final Set<String> _removedUserCodes = {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final filteredUsers = widget.users.where((user) {
      if (_removedUserCodes.contains(user.code)) return false;
      if (_query.trim().isEmpty) return true;
      final query = _query.toLowerCase();
      return user.name.toLowerCase().contains(query) || user.code.toLowerCase().contains(query);
    }).toList();

    return RolesManagementSectionCard(
      title: 'User Assignment',
      trailing: GestureDetector(
        onTap: () {}, // Handle assignment
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.securityManager.addUser.path,
                width: 14.w,
                height: 14.w,
                color: AppColors.primary,
              ),
              Gap(4.w),
              Text(
                'Assign',
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search users...',
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
            onChanged: (value) => setState(() => _query = value),
          ),
          Gap(16.h),
          if (filteredUsers.isEmpty)
            const RolesManagementEmptyBody(message: 'No assigned users found.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _AssignedUserMobileTile(user: user, onRemove: () => _handleRemoveUser(user));
              },
            ),
        ],
      ),
    );
  }

  Future<void> _handleRemoveUser(RoleAssignedUser user) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Remove User',
      message: 'Remove this user from the role?',
      itemName: user.name,
      confirmText: 'Remove',
    );

    if (!mounted || confirmed != true) return;

    setState(() => _removedUserCodes.add(user.code));
    ToastService.success(context, '${user.name} removed', title: 'Removed');
  }
}

class _AssignedUserMobileTile extends StatelessWidget {
  const _AssignedUserMobileTile({required this.user, required this.onRemove});

  final RoleAssignedUser user;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          AppAvatar(fallbackInitial: user.name, size: 36.w),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(2.h),
                Text(
                  'ID: ${user.code}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          DigifyAssetButton(
            assetPath: Assets.icons.securityManager.removeUser.path,
            onTap: onRemove,
            width: 20.w,
            height: 20.w,
            color: AppColors.deleteIconRed,
          ),
        ],
      ),
    );
  }
}
