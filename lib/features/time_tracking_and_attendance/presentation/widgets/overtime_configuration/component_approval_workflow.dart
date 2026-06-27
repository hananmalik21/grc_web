import 'package:grc/core/widgets/common/digify_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/overtime_configuration/overtime_configuration_provider.dart';

class ComponentApprovalWorkflow extends ConsumerWidget {
  const ComponentApprovalWorkflow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overtimeConfigurationProvider);
    final notifier = ref.read(overtimeConfigurationProvider.notifier);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.attendanceMainIcon.path,
                color: AppColors.primary,
                height: 28.h,
                width: 28.w,
              ),
              Gap(8.w),
              Text(
                'Approval Workflow',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(24.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ApprovalConfigurationTile(
                title: 'Manager Approval Required',
                description:
                    'All requests must be approved by direct supervisor',
                value: state.isManagerApprovalRequired,
                onChanged: (value) =>
                    notifier.toggleManagerApprovalRequired(value),
                iconPath: Assets.icons.sidebar.scheduleAssignments.path,
              ),
              Gap(16.h),
              ApprovalConfigurationTile(
                title: 'HR Validation Required',
                description:
                    'Final validation by HR department before payroll processing',
                value: state.isHRValidationRequired,
                onChanged: (value) =>
                    notifier.toggleHRValidationRequired(value),
                iconPath: Assets.icons.divisionStatIcon.path,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApprovalConfigurationTile extends StatelessWidget {
  const ApprovalConfigurationTile({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.iconPath,
  });

  final String title;
  final String description;
  final String iconPath;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.grayBgDark
            : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: DigifyAsset(
                assetPath: iconPath,
                width: 24,
                height: 24,
                color: AppColors.primary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4.h),
                Text(
                  description,
                  style: context.textTheme.labelSmall?.copyWith(),
                ),
              ],
            ),
          ),
          Gap(16.w),
          DigifySwitch(
            value: value,
            onChanged: onChanged,
            trackOutlineColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
