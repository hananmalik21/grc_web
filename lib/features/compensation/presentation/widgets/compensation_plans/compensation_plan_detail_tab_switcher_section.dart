import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompensationPlanDetailTabSwitcherSection extends StatelessWidget {
  const CompensationPlanDetailTabSwitcherSection({super.key});

  static const List<String> _tabs = <String>[
    'Overview',
    'Components',
    'Eligibility',
    'Employees',
    'Analytics',
    'Workflow',
    'Audit Log',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final requiresScrollableTabs = availableWidth < 1120.w;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            ),
            child: TabBar(
              isScrollable: requiresScrollableTabs,
              tabAlignment: requiresScrollableTabs ? TabAlignment.start : TabAlignment.fill,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: requiresScrollableTabs ? EdgeInsets.symmetric(horizontal: 18.w) : EdgeInsets.zero,
              padding: EdgeInsets.zero,
              splashBorderRadius: BorderRadius.circular(999.r),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.primary.withValues(alpha: 0.08);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.primary.withValues(alpha: 0.04);
                }
                return Colors.transparent;
              }),
              indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999.r)),
              labelColor: AppColors.cardBackground,
              unselectedLabelColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              labelStyle: context.textTheme.titleSmall,
              unselectedLabelStyle: context.textTheme.titleSmall,
              tabs: _tabs
                  .map(
                    (tab) => Tab(
                      height: 36.h,
                      child: Center(child: Text(tab, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
