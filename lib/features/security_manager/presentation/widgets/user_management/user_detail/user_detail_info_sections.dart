import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../../core/widgets/common/digify_square_capsule.dart';
import '../../../../../../features/security_manager/domain/models/user_detail_data.dart';
import '../../../../../../gen/assets.gen.dart';
import 'user_detail_shared_widgets.dart';

class UserDetailLoginAccessSection extends StatelessWidget {
  final UserDetailData detail;

  const UserDetailLoginAccessSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return UserDetailSectionCard(
      title: 'Login & Access',
      iconPath: Assets.icons.lockIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetailInfoTile(
            svgPath: Assets.icons.employeeManagement.user.path,
            label: 'Username',
            value: detail.displayUsername,
          ),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            label: 'Account Status',
            value: detail.displayAccountStatus,
            subLabel: detail.isAccountActive ? 'Account is active & accessible' : 'Account is locked or inactive',
          ),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            label: 'Password Status',
            value: detail.displayPasswordStatus,
            subLabel: detail.forcePasswordChange
                ? 'Password change required on next login'
                : 'Password meets security requirements',
          ),
          DigifyDivider.horizontal(height: 24.h),
          const UserDetailInfoTile(label: 'Last Password Change', value: '--'),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            label: 'Failed Login Count',
            value: detail.displayFailedAttempts,
            subLabel: '${detail.failedLoginAttempts} failed attempt(s) recorded',
          ),
        ],
      ),
    );
  }
}

class UserDetailAuthenticationSection extends StatelessWidget {
  final UserDetailData detail;

  const UserDetailAuthenticationSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return UserDetailSectionCard(
      title: 'Authentication',
      iconPath: Assets.icons.securityIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetailInfoTile(
            svgPath: Assets.icons.securityIcon.path,
            label: 'MFA Status',
            value: detail.displayMfaStatus,
            subLabel: detail.mfaRequired
                ? 'Multi-factor authentication is enabled'
                : 'Multi-factor authentication is not enabled',
          ),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            svgPath: Assets.icons.emailEnvelopeGray.path,
            label: 'Recovery Email',
            value: detail.displaySecondaryEmail,
          ),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            svgPath: Assets.icons.phoneIcon.path,
            label: 'Recovery Phone',
            value: detail.displayMobilePhone,
          ),
          DigifyDivider.horizontal(height: 24.h),
          UserDetailInfoTile(
            svgPath: Assets.icons.clockIcon.path,
            label: 'Session Timeout',
            value: detail.displaySessionTimeout,
            subLabel: 'Automatic logout after inactivity',
          ),
        ],
      ),
    );
  }
}

class UserDetailRolesSection extends StatelessWidget {
  final List<String> roles;

  const UserDetailRolesSection({super.key, required this.roles});

  @override
  Widget build(BuildContext context) {
    final normalizedRoles = roles.where((role) => role.trim().isNotEmpty).toList();
    return UserDetailSectionCard(
      title: 'Roles & Permissions',
      iconPath: Assets.icons.securityManager.applicationRoles.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: normalizedRoles.isEmpty
                ? [
                    DigifySquareCapsule(
                      label: '--',
                      backgroundColor: AppColors.dashAttendance.withValues(alpha: .1),
                      textColor: AppColors.dashAttendance,
                      borderColor: AppColors.dashAttendance,
                    ),
                  ]
                : normalizedRoles
                      .map(
                        (role) => DigifySquareCapsule(
                          label: role,
                          backgroundColor: AppColors.dashAttendance.withValues(alpha: .1),
                          textColor: AppColors.dashAttendance,
                          borderColor: AppColors.dashAttendance,
                        ),
                      )
                      .toList(),
          ),
          Gap(12.h),
          Text(
            'User has ${normalizedRoles.length} role(s) assigned with associated permissions',
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.grayBorderDark),
          ),
        ],
      ),
    );
  }
}
