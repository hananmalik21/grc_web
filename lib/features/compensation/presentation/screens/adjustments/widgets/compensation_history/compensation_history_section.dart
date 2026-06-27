import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/compensation/domain/models/adjustments/employee_component_history.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/employee_component_history_provider.dart';
import '../../../../widgets/create_employee_compensation/compensation_section_card.dart';
import 'compensation_history_skeleton.dart';

class CompensationHistorySection extends ConsumerWidget {
  const CompensationHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(employeeComponentHistoryProvider);

    return CompensationSectionCard(
      title: 'Compensation History',
      child: historyAsync.when(
        loading: () => const CompensationHistorySkeleton(),
        error: (_, _) => const _EmptyHistory(),
        data: (items) {
          if (items.isEmpty) return const _EmptyHistory();
          return HistoryList(items: items);
        },
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Text(
          'No compensation history available',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class HistoryList extends StatelessWidget {
  final List<EmployeeComponentHistory> items;

  const HistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          HistoryTimelineItem(item: items[i], showConnector: i != items.length - 1),
      ],
    );
  }
}

class HistoryTimelineItem extends StatelessWidget {
  final EmployeeComponentHistory item;
  final bool showConnector;

  const HistoryTimelineItem({super.key, required this.item, required this.showConnector});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final history = item.latestHistory;
    final connectorColor = isDark ? AppColors.borderGreyDark : AppColors.cardBorder;
    final amountText = history.amountChangeText;
    final amountColor = switch (history.changeDirection) {
      AmountChangeDirection.increase => AppColors.success,
      AmountChangeDirection.decrease => AppColors.alertCritical,
      AmountChangeDirection.same => AppColors.infoText,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: showConnector ? 10.h : 0),
      child: Stack(
        children: [
          if (showConnector)
            Positioned(
              left: (24.w - 2.w) / 2,
              top: 28.h,
              bottom: 0,
              child: Container(width: 2.w, color: connectorColor),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DigifyAsset(
                    assetPath: Assets.icons.auditTrailIconDepartment.path,
                    color: AppColors.primary,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.componentName,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Gap(16.w),
                        Text(
                          history.effectiveDate,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 12.sp,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    Text(
                      history.eventTitle,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      '${history.currencyCode} $amountText',
                      style: context.textTheme.bodyMedium?.copyWith(color: amountColor),
                    ),
                    Gap(4.h),
                    Row(
                      children: [
                        AppAvatar(size: 24.w, fallbackInitial: history.approverName),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            'Approved by ${history.approverName}'
                            ' - ${history.approverRole}',
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 12.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
