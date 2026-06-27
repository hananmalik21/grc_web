import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../features/security_manager/domain/models/system_user.dart';
import '../../../../../features/security_manager/domain/models/user_detail_data.dart';
import '../../providers/user_management/user_detail_provider.dart';
import '../../widgets/user_management/user_detail/user_detail_header_section.dart';
import '../../widgets/user_management/user_detail/user_detail_info_sections.dart';
import '../../widgets/user_management/user_detail/user_detail_quick_actions_section.dart';
import '../../widgets/user_management/user_detail/user_detail_status_cards_section.dart';

class UserDetailScreen extends ConsumerWidget {
  static const String routeName = 'security-manager-user-show';

  final SystemUser? user;

  const UserDetailScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground;
    final userGuid = user?.userGuid ?? '';

    if (userGuid.isEmpty) {
      return Container(
        color: bgColor,
        child: const Center(child: Text('No user selected.')),
      );
    }

    final detailAsync = ref.watch(userDetailProvider(userGuid));

    return Container(
      color: bgColor,
      child: detailAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLoadingIndicator(size: 48.r),
              Gap(16.h),
              Text(
                'Loading user details...',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load user details.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(12.h),
              TextButton(onPressed: () => ref.invalidate(userDetailProvider(userGuid)), child: const Text('Retry')),
            ],
          ),
        ),
        data: (detail) => _UserDetailContent(detail: detail),
      ),
    );
  }
}

class _UserDetailContent extends StatelessWidget {
  final UserDetailData detail;

  const _UserDetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: ResponsiveHelper.getDetailScreenPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetailHeaderSection(detail: detail),
          Gap(24.h),
          UserDetailStatusCardsSection(detail: detail),
          Gap(24.h),
          UserDetailLoginAccessSection(detail: detail),
          Gap(24.h),
          UserDetailAuthenticationSection(detail: detail),
          Gap(24.h),
          UserDetailRolesSection(roles: detail.roleNames),
          Gap(24.h),
          const UserDetailQuickActionsSection(),
        ],
      ),
    );
  }
}
