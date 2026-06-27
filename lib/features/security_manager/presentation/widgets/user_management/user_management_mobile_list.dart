import 'package:grc/features/security_manager/presentation/screens/user_management/user_management_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/buttons/app_mobile_button.dart';
import '../../../../../core/widgets/common/app_avatar.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/common/digify_status_capsule.dart';
import '../../../../../core/widgets/common/pagination_controls.dart';
import '../../../../../core/widgets/mobile/mobile_state_card.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/system_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_management_delete_mixin.dart';
import 'user_security_status.dart';
import '../../screens/user_management/user_detail_screen.dart';
import '../../screens/user_management/edit_user_mobile_sheet.dart';

class UserManagementMobileList extends ConsumerWidget {
  const UserManagementMobileList({
    super.key,
    required this.users,
    required this.isDark,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
    this.onPrevious,
    this.onNext,
    this.isLoading = false,
  });

  final List<SystemUser> users;
  final bool isDark;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  static SystemUser _skeletonUser() => const SystemUser(
    id: 0,
    userGuid: '',
    username: '',
    name: 'Employee Full Name',
    email: 'employee@company.com',
    employeeNumber: 'EMP-0000',
    department: 'Department Name',
    designation: 'Designation Title',
    roles: ['Role One', 'Role Two'],
    status: SystemUserStatus.active,
    is2FAEnabled: true,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayUsers = isLoading && users.isEmpty ? List.generate(5, (_) => _skeletonUser()) : users;

    if (!isLoading && users.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        iconBackground: AppColors.primary.withValues(alpha: 0.08),
        iconPath: Assets.icons.usersIcon.path,
        iconColor: AppColors.primary,
        title: 'No Users Found',
        subtitle: 'No users match your current filters.\nTry adjusting your search or add a new user.',
      );
    }

    return Column(
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayUsers.length,
            separatorBuilder: (_, _) => Gap(8.h),
            itemBuilder: (context, index) => _UserMobileCard(user: displayUsers[index], isDark: isDark),
          ),
        ),
        Gap(16.h),
        PaginationControls(
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          pageSize: pageSize,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
          onPrevious: onPrevious,
          onNext: onNext,
          isLoading: false,
          style: PaginationStyle.simple,
        ),
      ],
    );
  }
}

class _UserMobileCard extends ConsumerWidget with UserManagementDeleteMixin, UserManagementPermissionMixin {
  const _UserMobileCard({required this.user, required this.isDark});

  final SystemUser user;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final isDeleting = isUserDeleting(ref, user.userGuid);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                image: null,
                fallbackInitial: user.initials,
                size: 44.w,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      user.email,
                      style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
                    ),
                    Text(
                      user.displayEmployeeNumber,
                      style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: user.displayStatus),
            ],
          ),
          Gap(10.h),
          Divider(height: 1, color: dividerColor),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayDepartment,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      user.displayDesignation,
                      style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
                    ),
                  ],
                ),
              ),
              UserSecurityStatus(is2FAEnabled: user.is2FAEnabled),
            ],
          ),
          if (user.roles.isNotEmpty) ...[
            Gap(10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: user.roles
                  .map(
                    (role) => DigifyCapsule(
                      label: role,
                      backgroundColor: AppColors.roleBadgeBg,
                      textColor: AppColors.roleBadgeText,
                      borderColor: AppColors.roleBadgeBorder,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    ),
                  )
                  .toList(),
            ),
          ],
          Gap(10.h),
          Divider(height: 1, color: dividerColor),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canUpdateUser)
                AppMobileButton.primary(
                  svgPath: Assets.icons.editIconPurple.path,
                  onPressed: () => EditUserMobileSheet.show(context, user),
                ),
              if (canViewUser) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.blueEyeIcon.path,
                  backgroundColor: AppColors.textSecondary,
                  foregroundColor: Colors.white,
                  onPressed: () => context.pushNamed(UserDetailScreen.routeName, extra: user),
                ),
              ],
              if (canDeleteUser) ...[
                Gap(8.w),
                AppMobileButton.danger(
                  svgPath: Assets.icons.deleteIconRed.path,
                  isLoading: isDeleting,
                  onPressed: () async {
                    await confirmAndDeleteUser(context: context, ref: ref, user: user);
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
