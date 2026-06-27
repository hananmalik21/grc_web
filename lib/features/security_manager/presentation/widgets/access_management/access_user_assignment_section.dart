import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/app_avatar.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../dialogs/access_management/assign_user_form_dialog.dart';
import '../../providers/access_management/access_management_provider.dart';
import 'access_section_card.dart';

class AccessUserAssignmentSection extends ConsumerWidget {
  const AccessUserAssignmentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleDetail = ref.watch(accessManagementProvider).roleDetail;

    return AccessSectionCard(
      title: 'User Assignment',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 300.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  AssignedUserTile(user: roleDetail!.assignedUsers[index]),
              separatorBuilder: (context, index) => Gap(12.h),
              itemCount: roleDetail?.assignedUsers.length ?? 0,
            ),
            Gap(24.h),
            SizedBox(
              width: context.deviceWidth,
              child: AppButton(
                label: 'Add User',
                backgroundColor: AppColors.primary.withValues(alpha: .1),
                foregroundColor: AppColors.primary,
                svgPath: Assets.icons.addEmployeeIcon.path,
                type: AppButtonType.outline,
                onPressed: () =>
                    AssignUserFormDialog.show(context, role: roleDetail!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignedUserTile extends StatelessWidget {
  const AssignedUserTile({super.key, required this.user});

  final AccessAssignedUser user;

  @override
  Widget build(BuildContext context) {
    final titleColor = context.isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final subtitleColor = context.isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.backgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          AppAvatar(fallbackInitial: user.name),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? "N/A",
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  user.email ?? "N/A",
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
                'Assigned',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: context.isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              Gap(4.h),
              Text(
                user.assignedDate == null
                    ? "--/--/--"
                    : DateFormat('dd MMM yyyy').format(user.assignedDate!),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
