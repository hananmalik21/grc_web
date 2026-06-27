import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/responsive_service.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../providers/user_management/user_management_provider.dart';
import '../../widgets/user_management/search_and_filter_desktop.dart';
import '../../widgets/user_management/search_and_filter_mobile.dart';
import '../../widgets/user_management/user_management_mobile_list.dart';
import '../../widgets/user_management/user_management_table.dart';
import '../../widgets/user_management/user_summary_stats.dart';

class UserManagementContent extends ConsumerWidget {
  const UserManagementContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(userManagementProvider);
    final notifier = ref.read(userManagementProvider.notifier);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final isMobile = context.isMobileLayout;

    void onPrevious() => notifier.setPage(state.currentPage - 1);
    void onNext() => notifier.setPage(state.currentPage + 1);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            const UserSummaryStats(),
            Gap(sectionSpacing),
            if (isMobile) const UserManagementSearchAndFilterMobile() else const UserManagementSearchAndFilterDesktop(),
            Gap(sectionSpacing),
            if (isMobile)
              UserManagementMobileList(
                users: state.users,
                isDark: isDark,
                isLoading: state.isLoading,
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                hasNext: state.hasNext,
                hasPrevious: state.hasPrevious,
                onPrevious: state.hasPrevious ? onPrevious : null,
                onNext: state.hasNext ? onNext : null,
              )
            else
              const UserManagementTable(),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}
