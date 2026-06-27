import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../providers/salary_structure_creation_provider.dart';
import 'creation_common_widgets.dart';

class AdvancedSettingsStep extends ConsumerWidget {
  const AdvancedSettingsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);

    return Column(
      children: [
        // System Integration Section
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreationSectionHeader(title: 'System Integration', icon: Icons.settings_outlined),
              Gap(20.h),
              CreationSettingTile(
                title: 'Enable Payroll Integration',
                description: 'Automatically sync this structure with the payroll system for seamless processing',
                value: state.payrollIntegrationEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(payrollIntegrationEnabled: val),
              ),
              Gap(12.h),
              CreationSettingTile(
                title: 'Auto-Calculate Component Values',
                description: 'Automatically calculate derived components based on predefined formulas',
                value: state.autoCalculateComponentsEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(autoCalculateComponentsEnabled: val),
              ),
            ],
          ),
        ),
        Gap(24.h),
        // Governance & Control Section
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreationSectionHeader(title: 'Governance & Control', icon: Icons.shield_outlined),
              Gap(20.h),
              CreationSettingTile(
                title: 'Enable Version Control',
                description: 'Maintain version history and track all changes made to this structure',
                value: state.versionControlEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(versionControlEnabled: val),
              ),
              Gap(12.h),
              CreationSettingTile(
                title: 'Require Multi-Stage Approval',
                description: 'Enforce approval workflow for changes to this salary structure',
                value: state.multiStageApprovalEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(multiStageApprovalEnabled: val),
              ),
              Gap(12.h),
              CreationSettingTile(
                title: 'Enable Audit Logging',
                description: 'Log all activities and changes for compliance and audit purposes',
                value: state.auditLoggingEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(auditLoggingEnabled: val),
              ),
              Gap(12.h),
              CreationSettingTile(
                title: 'Allow Manual Overrides',
                description: 'Permit authorized users to override calculated values on a case-by-case basis',
                value: state.manualOverridesEnabled,
                onChanged: (val) => notifier.updateAdvancedSettings(manualOverridesEnabled: val),
              ),
            ],
          ),
        ),
        Gap(24.h),
        // Configuration Complete Banner
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.infoCircleBlue.path,
                width: 20.w,
                height: 20.w,
                color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration Complete',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.infoTextDark : AppColors.sidebarFooterTitle,
                        fontSize: 14.sp,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      "You've configured all settings for this salary structure. Review your selections and click 'Save Structure' to finalize the creation, or use the 'Previous' button to make any changes.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
