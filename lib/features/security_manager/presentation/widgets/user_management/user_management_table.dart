import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/security_manager/data/config/user_management_table_config.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_table_width_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'user_management_table_header.dart';
import 'user_management_table_row.dart';

class UserManagementTable extends ConsumerWidget {
  const UserManagementTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tableState = ref.watch(userManagementTableWidthsProvider);
    final state = ref.watch(userManagementProvider);
    final skeletonRows = ref.watch(userManagementSkeletonRowsProvider);
    final isLoading = state.isLoading;
    final errorMessage = state.error;
    final liveRows = state.users;
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;

    final baseWidth =
        (UserManagementTableConfig.showActions ? UserManagementTableConfig.actionsWidth : 0) +
        tableState.columnOrder.fold<double>(0, (sum, col) => sum + tableState.widthFor(col));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final widthMultiplier = availableWidth > baseWidth ? availableWidth / baseWidth : 1.0;
              final totalWidth = baseWidth * widthMultiplier;

              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: 540.h),
                child: ScrollableSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: errorMessage != null && liveRows.isEmpty
                        ? _buildErrorState(context, ref, errorMessage, totalWidth)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserManagementTableHeader(isDark: isDark, widthMultiplier: widthMultiplier),
                              Skeletonizer(
                                enabled: isLoading,
                                child: Column(
                                  children: [
                                    for (final user in rows)
                                      UserManagementTableRow(
                                        user: user,
                                        isDark: isDark,
                                        widthMultiplier: widthMultiplier,
                                      ),
                                  ],
                                ),
                              ),
                              if (!isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.employeeListIcon.path,
                                  title: 'No Users Found',
                                  message: 'There are no users matching your search or filters.',
                                ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          PaginationControls(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: UserManagementTableConfig.pageSize,
            hasNext: state.hasNext,
            hasPrevious: state.hasPrevious,
            isLoading: false,
            onPrevious: state.hasPrevious && !isLoading
                ? () => ref.read(userManagementProvider.notifier).setPage(state.currentPage - 1)
                : null,
            onNext: state.hasNext && !isLoading
                ? () => ref.read(userManagementProvider.notifier).setPage(state.currentPage + 1)
                : null,
            showBorder: true,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String errorMessage, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load users', style: context.textTheme.titleMedium?.copyWith(color: AppColors.error)),
            Gap(8.h),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            Gap(16.h),
            AppButton.outline(label: 'Retry', onPressed: () => ref.read(userManagementProvider.notifier).getUsers()),
          ],
        ),
      ),
    );
  }
}
