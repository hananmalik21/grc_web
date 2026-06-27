import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/payroll/domain/models/flow_monitor_task.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_tab_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:gap/gap.dart';

class FlowMonitorTaskTile extends StatelessWidget {
  const FlowMonitorTaskTile({required this.task, required this.isExpanded, required this.onToggle, super.key});

  final FlowMonitorTask task;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : const Color(0xFFF3F4F6);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FlowMonitorTaskHeader(task: task, isExpanded: isExpanded, onToggle: onToggle),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _FlowMonitorTaskExpandedBody(task: task),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _FlowMonitorTaskHeader extends StatelessWidget {
  const _FlowMonitorTaskHeader({required this.task, required this.isExpanded, required this.onToggle});

  final FlowMonitorTask task;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final statusLabel = FlowMonitorTabConfig.statusLabel(loc, task.status);
    final typeLabel = FlowMonitorTabConfig.taskTypeLabel(loc, task.type);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 20.h, 24.w, 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(4.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _FlowMonitorTypeBadge(label: typeLabel),
                    Text(
                      loc.payrollFlowMonitorTaskNumber(task.number),
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(16.w),
          DigifyCapsule(
            label: statusLabel,
            iconPath: Assets.icons.clockIcon.path,
            backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
            textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            borderRadius: 999.r,
            padding: EdgeInsetsDirectional.fromSTEB(14.w, 5.h, 14.w, 5.h),
          ),
          Gap(8.w),
          _FlowMonitorIconButton(iconPath: Assets.icons.employeeManagement.more.path, onTap: () {}),
          Gap(8.w),
          _FlowMonitorIconButton(
            iconPath: Assets.icons.workforce.chevronDown.path,
            onTap: onToggle,
            rotateTurns: isExpanded ? 0.5 : 0,
          ),
        ],
      ),
    );
  }
}

class _FlowMonitorTypeBadge extends StatelessWidget {
  const _FlowMonitorTypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8.w, 2.h, 8.w, 2.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _FlowMonitorIconButton extends StatelessWidget {
  const _FlowMonitorIconButton({required this.iconPath, required this.onTap, this.rotateTurns = 0});

  final String iconPath;
  final VoidCallback onTap;
  final double rotateTurns;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final iconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Material(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Center(
            child: AnimatedRotation(
              turns: rotateTurns,
              duration: const Duration(milliseconds: 200),
              child: DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlowMonitorTaskExpandedBody extends StatelessWidget {
  const _FlowMonitorTaskExpandedBody({required this.task});

  final FlowMonitorTask task;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final statusLabel = FlowMonitorTabConfig.statusLabel(loc, task.status);
    final detailBg = isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFFAFAFA);
    final borderColor = isDark ? AppColors.cardBorderDark : const Color(0xFFF3F4F6);
    final columnCount = switch (ResponsiveHelper.getDeviceType(context)) {
      DeviceType.mobile => 1,
      DeviceType.tablet => 2,
      DeviceType.web => 4,
    };

    final fields = <_FlowMonitorDetailField>[
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorActivity,
        value: _FlowMonitorActivityLink(label: task.activity ?? task.title),
      ),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorSubmittedBy,
        value: Text(task.submittedBy ?? loc.payrollFlowMonitorNotAvailable),
      ),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorSubmissionDate,
        value: Text(task.submissionDate ?? loc.payrollFlowMonitorNotAvailable),
      ),
      _FlowMonitorDetailField(label: loc.payrollFlowMonitorStatus, value: Text(statusLabel)),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorOwner,
        value: Text(task.owner ?? loc.payrollFlowMonitorNotAvailable),
      ),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorLoggingLevel,
        value: Text(task.loggingLevel ?? loc.payrollFlowMonitorNotAvailable),
      ),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorOwnerType,
        value: Text(task.ownerType ?? loc.payrollFlowMonitorNotAvailable),
      ),
      _FlowMonitorDetailField(
        label: loc.payrollFlowMonitorRecords,
        value: Text(task.records ?? loc.payrollFlowMonitorNotAvailable),
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: detailBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.w, 25.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FlowMonitorSectionTitle(title: loc.payrollFlowMonitorTaskDetails),
            Gap(16.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - ((columnCount - 1) * 16.w)) / columnCount;

                return Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: fields
                      .map(
                        (field) => SizedBox(width: columnCount == 1 ? constraints.maxWidth : itemWidth, child: field),
                      )
                      .toList(),
                );
              },
            ),
            Gap(20.h),
            _FlowMonitorSectionTitle(title: loc.payrollFlowMonitorOutputs),
            Gap(12.h),
            _FlowMonitorOutputsEmptyState(message: loc.payrollFlowMonitorNoOutputs),
          ],
        ),
      ),
    );
  }
}

class _FlowMonitorSectionTitle extends StatelessWidget {
  const _FlowMonitorSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      title.toUpperCase(),
      style: context.textTheme.labelMedium?.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.65,
        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF374151),
      ),
    );
  }
}

class _FlowMonitorDetailField extends StatelessWidget {
  const _FlowMonitorDetailField({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
          ),
        ),
        Gap(3.h),
        DefaultTextStyle(
          style:
              context.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ) ??
              const TextStyle(),
          child: value,
        ),
      ],
    );
  }
}

class _FlowMonitorActivityLink extends StatelessWidget {
  const _FlowMonitorActivityLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          Gap(6.w),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: DigifyAsset(
              assetPath: Assets.icons.compensation.link.path,
              width: 10,
              height: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowMonitorOutputsEmptyState extends StatelessWidget {
  const _FlowMonitorOutputsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: Assets.icons.reportsIcon.path,
              width: 22,
              height: 22,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
