import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveFilterTabs extends ConsumerWidget {
  const LeaveFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedFilter = ref.watch(leaveFilterProvider);
    final isMobile = context.isMobile;

    final tabs = [
      (LeaveFilter.all, localizations.leaveFilterAll),
      (LeaveFilter.draft, localizations.leaveFilterDraft),
      (LeaveFilter.pending, localizations.leaveFilterPending),
      (LeaveFilter.approved, localizations.leaveFilterApproved),
      (LeaveFilter.rejected, localizations.leaveFilterRejected),
    ];

    final row = Row(
      mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
      children: [
        for (int i = 0; i < tabs.length; i++) ...[
          if (i > 0) Gap(8.w),
          _FilterTab(
            label: tabs[i].$2,
            isSelected: selectedFilter == tabs[i].$1,
            onTap: () => ref.read(leaveFilterProvider.notifier).setFilter(tabs[i].$1),
            isDark: isDark,
            isMobile: isMobile,
          ),
        ],
      ],
    );

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: row,
      );
    }

    return row;
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final bool isMobile;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final textColor = isSelected
        ? AppColors.buttonTextLight
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isSelected
                ? null
                : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14.w : 16.w,
            vertical: isMobile ? 9.h : 8.h,
          ),
          child: Text(
            label.capitalizeFirst,
            style: (isMobile ? context.textTheme.bodyMedium : context.textTheme.bodyLarge)
                ?.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
