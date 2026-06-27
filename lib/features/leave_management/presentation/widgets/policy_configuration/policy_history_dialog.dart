import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/leave_management/domain/models/policy_history.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_history_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyHistoryDialog extends ConsumerWidget {
  final String policyName;

  const PolicyHistoryDialog({super.key, required this.policyName});

  static Future<void> show(BuildContext context, String policyName) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: true,
      builder: (context) => PolicyHistoryDialog(policyName: policyName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final historyAsync = ref.watch(policyHistoryProvider(policyName));

    return AppDialog(
      title: 'Version History',
      width: 600.w,
      content: historyAsync.when(
        data: (historyList) {
          if (historyList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'No history available',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...historyList.map(
                (history) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _PolicyHistoryItem(history: history, isDark: isDark),
                ),
              ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(child: AppLoadingIndicator()),
        ),
        error: (error, stackTrace) => Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Text(
              'Error loading history: ${error.toString()}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.errorTextDark : AppColors.errorText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyHistoryItem extends StatelessWidget {
  final PolicyHistory history;
  final bool isDark;

  const _PolicyHistoryItem({required this.history, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(color: AppColors.jobRoleBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: Assets.icons.leaveManagement.history.path,
              width: 20,
              height: 20,
              color: AppColors.primary,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(4.r)),
                      child: Text(
                        'v${history.version}',
                        style: context.textTheme.labelMedium?.copyWith(color: AppColors.primary, fontSize: 11.sp),
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      '${history.date} by ${history.author}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  history.description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
