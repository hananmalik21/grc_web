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
import 'roles_management_common_widgets.dart';
import 'roles_management_surface_card.dart';

class RolesManagementUserAssignmentCard extends StatefulWidget {
  const RolesManagementUserAssignmentCard({super.key, required this.users});

  final List<RoleAssignedUser> users;

  @override
  State<RolesManagementUserAssignmentCard> createState() => _RolesManagementUserAssignmentCardState();
}

class _RolesManagementUserAssignmentCardState extends State<RolesManagementUserAssignmentCard> {
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
    final filteredUsers = widget.users.where((user) {
      if (_removedUserCodes.contains(user.code)) return false;
      if (_query.trim().isEmpty) return true;
      final query = _query.toLowerCase();
      return user.name.toLowerCase().contains(query) || user.code.toLowerCase().contains(query);
    }).toList();

    return RolesManagementSectionCard(
      title: 'User Assignment',
      trailing: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.infoBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.infoBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(assetPath: Assets.icons.securityManager.addUser.path),
            Gap(6.w),
            Text(
              'Assign Users',
              style: context.textTheme.labelLarge?.copyWith(color: AppColors.primary, fontSize: 11.sp),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search users...',
            filled: true,
            fillColor: Colors.transparent,
            onChanged: (value) => setState(() => _query = value),
          ),
          Gap(14.h),
          if (filteredUsers.isEmpty)
            const RolesManagementEmptyBody(message: 'No assigned users match the current search.')
          else
            Column(
              spacing: 8.h,
              children: filteredUsers
                  .map((user) => _AssignedUserTile(user: user, onRemove: () => _handleRemoveTap(user)))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void _handleRemoveTap(RoleAssignedUser user) {
    _handleRemoveUser(user);
  }

  Future<void> _handleRemoveUser(RoleAssignedUser user) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Remove User',
      message: 'Are you sure you want to remove this user from the role assignment?',
      itemName: '${user.name} (${user.code})',
      confirmText: 'Remove',
      cancelText: 'Cancel',
    );

    if (!mounted || confirmed != true) return;

    setState(() => _removedUserCodes.add(user.code));
    ToastService.success(context, '${user.name} removed from assignment', title: 'Removed');
  }
}

class _AssignedUserTile extends StatelessWidget {
  const _AssignedUserTile({required this.user, required this.onRemove});

  final RoleAssignedUser user;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          AppAvatar(fallbackInitial: user.name, size: 30.w),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(2.h),
                Text(
                  'ID: ${user.code}',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.sidebarSecondaryText,
                  ),
                ),
              ],
            ),
          ),
          DigifyAssetButton(
            assetPath: Assets.icons.securityManager.removeUser.path,
            onTap: onRemove,
            width: 18,
            height: 18,
            color: AppColors.deleteIconRed,
          ),
        ],
      ),
    );
  }
}
