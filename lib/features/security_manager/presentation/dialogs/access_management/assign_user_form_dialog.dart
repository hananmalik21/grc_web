import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/app_avatar.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../providers/access_management/access_assign_user_form_provider.dart';

class AssignUserFormDialog extends ConsumerStatefulWidget {
  const AssignUserFormDialog({super.key, required this.role});

  final AccessRoleDetail role;

  static void show(BuildContext context, {required AccessRoleDetail role}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AssignUserFormDialog(role: role),
    );
  }

  @override
  ConsumerState<AssignUserFormDialog> createState() =>
      _AssignUserFormDialogState();
}

class _AssignUserFormDialogState extends ConsumerState<AssignUserFormDialog> {
  final formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accessAssignUserFormProvider);
    final notifier = ref.read(accessAssignUserFormProvider.notifier);
    return AppDialog(
      title: 'Assigned Users to Role',
      onClose: () {
        notifier.reset();
        context.pop();
      },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.primary.withValues(alpha: .1),
              border: Border.all(
                color: context.isDark
                    ? AppColors.borderGreyDark
                    : AppColors.borderGrey,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assigning users to role",
                  style: context.labelSmall.copyWith(),
                ),
                Gap(8.h),
                Text(
                  widget.role.name,
                  style: context.labelLarge.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          Gap(24.h),
          DigifyTextField(
            labelText: 'Search Users',
            hintText: 'Search By name, email, or employee id...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIcon.path,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            onChanged: (value) => notifier.setSearchQuery(value),
            controller: _searchController,
          ),
          Gap(24.h),
          Text("Available Users", style: context.bodySmall),
          Gap(8.h),
          Container(
            constraints: BoxConstraints(minHeight: 200.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: context.isDark
                    ? AppColors.borderGreyDark
                    : AppColors.borderGrey,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => AssigningUserTile(
                user: state.filteredUsers[i],
                isSelected: state.assignedUserIds.contains(
                  state.filteredUsers[i].id,
                ),
                onTap: () => notifier.selectUser(state.filteredUsers[i].id!),
              ),
              separatorBuilder: (_, i) => DigifyDivider.horizontal(),
              itemCount: state.filteredUsers.length,
            ),
          ),
        ],
      ),
      actions: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: state.assignedUserIds.length.toString(),
                style: context.labelLarge,
              ),
              TextSpan(text: ' users selected'),
            ],
            style: context.labelMedium,
          ),
        ),
        Spacer(),
        AppButton(
          label: 'Cancel',
          onPressed: () {
            notifier.reset();
            context.pop();
          },
          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textSecondary,
        ),
        Gap(12.w),
        AppButton(
          label: 'Assign User',
          onPressed: () {},
          svgPath: Assets.icons.saveConfigIcon.path,
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}

class AssigningUserTile extends StatelessWidget {
  const AssigningUserTile({
    super.key,
    this.onTap,
    this.isSelected = false,
    required this.user,
  });

  final AccessAssignedUser user;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final titleColor = context.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final subtitleColor = context.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      leading: DigifyCheckbox(value: isSelected, onChanged: (value) {}),
      title: Row(
        children: [
          AppAvatar(fallbackInitial: user.name ?? ""),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? "",
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  user.email ?? "",
                  style: context.textTheme.labelSmall?.copyWith(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.code ?? "",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: context.isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              Gap(4.h),
              DigifyCapsule(
                label: 'Active',
                textColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: .1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
