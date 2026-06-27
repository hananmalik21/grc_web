import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/payroll/domain/models/flow_monitor_task.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_tab_config.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_task_tile.dart';
import 'package:grc/features/payroll/presentation/widgets/flow_monitor/flow_monitor_parameters_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FlowMonitorActivitiesSection extends StatefulWidget {
  const FlowMonitorActivitiesSection({super.key});

  @override
  State<FlowMonitorActivitiesSection> createState() => _FlowMonitorActivitiesSectionState();
}

class _FlowMonitorActivitiesSectionState extends State<FlowMonitorActivitiesSection> {
  FlowMonitorActivityTab _selectedTab = FlowMonitorActivityTab.overallActivities;
  int? _expandedTaskNumber;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final allTasks = FlowMonitorTabConfig.buildMockTasks(loc);
    final tabs = FlowMonitorTabConfig.buildActivityTabs(loc: loc, tasks: allTasks);
    final visibleTasks = FlowMonitorTabConfig.tasksForTab(_selectedTab, allTasks);
    final completedCount = allTasks.where((task) => task.isCompleted).length;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FlowMonitorActivityTabBar(
            tabs: tabs,
            selectedTab: _selectedTab,
            onTabSelected: (tab) => setState(() {
              _selectedTab = tab;
              _expandedTaskNumber = null;
            }),
          ),
          _FlowMonitorTasksHeader(
            completedCount: completedCount,
            totalCount: allTasks.length,
            visibleCount: visibleTasks.length,
          ),
          if (visibleTasks.isEmpty)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 32.h, 24.w, 40.h),
              child: Text(
                loc.payrollFlowMonitorNoTasks,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            )
          else
            Column(
              children: [
                for (final task in visibleTasks)
                  FlowMonitorTaskTile(
                    task: task,
                    isExpanded: _expandedTaskNumber == task.number,
                    onToggle: () => setState(() {
                      _expandedTaskNumber = _expandedTaskNumber == task.number ? null : task.number;
                    }),
                  ),
              ],
            ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.w, 24.h, 24.w, 24.h),
            child: const FlowMonitorParametersSection(),
          ),
        ],
      ),
    );
  }
}

class _FlowMonitorActivityTabBar extends StatelessWidget {
  const _FlowMonitorActivityTabBar({required this.tabs, required this.selectedTab, required this.onTabSelected});

  final List<FlowMonitorActivityTabData> tabs;
  final FlowMonitorActivityTab selectedTab;
  final ValueChanged<FlowMonitorActivityTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dividerColor = isDark ? AppColors.cardBorderDark : const Color(0xFFF3F4F6);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs)
              _FlowMonitorActivityTabButton(
                data: tab,
                isSelected: selectedTab == tab.tab,
                onTap: () => onTabSelected(tab.tab),
              ),
          ],
        ),
      ),
    );
  }
}

class _FlowMonitorActivityTabButton extends StatelessWidget {
  const _FlowMonitorActivityTabButton({required this.data, required this.isSelected, required this.onTap});

  final FlowMonitorActivityTabData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final badgeBg = isSelected
        ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.35) : AppColors.infoBg)
        : (isDark ? AppColors.grayBgDark : AppColors.grayBg);
    final badgeTextColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 18.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(assetPath: data.iconPath, width: 15, height: 15, color: labelColor),
            Gap(8.w),
            Text(
              data.label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: labelColor,
              ),
            ),
            Gap(8.w),
            Container(
              constraints: BoxConstraints(minWidth: 20.w),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 1.h),
              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999.r)),
              alignment: Alignment.center,
              child: Text(
                '${data.count}',
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: badgeTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowMonitorTasksHeader extends StatelessWidget {
  const _FlowMonitorTasksHeader({required this.completedCount, required this.totalCount, required this.visibleCount});

  final int completedCount;
  final int totalCount;
  final int visibleCount;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final dividerColor = isDark ? AppColors.cardBorderDark : const Color(0xFFF3F4F6);

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 20.h, 24.w, 17.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${loc.payrollFlowMonitorTasksTitle} ',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: loc.payrollFlowMonitorTasksCompletedSummary(completedCount, totalCount),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          DigifyAsset(
            assetPath: Assets.icons.tasksIcon.path,
            width: 14,
            height: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
          Gap(4.w),
          Text(
            loc.payrollFlowMonitorTasksCount(visibleCount),
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
