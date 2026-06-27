import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../gen/assets.gen.dart';
import '../widgets/setup_and_configuration/setup_progress_card.dart';
import '../widgets/setup_and_configuration/setup_step_card.dart';

class SetupAndConfigurationTab extends ConsumerStatefulWidget {
  const SetupAndConfigurationTab({super.key});

  @override
  ConsumerState<SetupAndConfigurationTab> createState() => _SetupAndConfigurationTabState();
}

class _SetupAndConfigurationTabState extends ConsumerState<SetupAndConfigurationTab> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          children: [
            const DigifyTabHeader(
              title: 'Compensation Module Setup',
              description:
                  'Complete the following configuration steps in sequence to set up your compensation management system',
            ),
            Gap(24.h),
            const SetupProgressCard(completedSteps: 3, totalSteps: 9),
            Gap(24.h),
            SetupStepCard(
              stepNumber: 1,
              title: 'Organization Structure',
              iconPath: Assets.icons.structureConfigurationIcon.path,
              description: 'Define departments, divisions, and cost centers for compensation planning',
              timeEstimation: '~10 mins',
              status: SetupStepStatus.completed,
              onActionPressed: () {},
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 2,
              title: 'Structure Types',
              iconPath: Assets.icons.compensation.fileList.path,
              description: 'Define salary structure types and templates for different compensation models',
              timeEstimation: '~10 mins',
              status: SetupStepStatus.completed,
              dependencies: const ['Organization Structure'],
              onActionPressed: () {},
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 3,
              title: 'Manage Salary Structure',
              iconPath: Assets.icons.compensation.layers.path,
              description: 'Create and manage salary structures with components, grades, and compensation rules',
              timeEstimation: '~15 mins',
              status: SetupStepStatus.completed,
              dependencies: const ['Structure Types'],
              onActionPressed: () {},
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 4,
              title: 'Compensation Components',
              iconPath: Assets.icons.timeManagementIcon.path,
              description: 'Configure salary components, allowances, benefits, and deductions',
              timeEstimation: '~20 mins',
              status: SetupStepStatus.inProgress,
              dependencies: const ['Manage Salary Structure'],
              onActionPressed: () {},
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 5,
              title: 'Compensation Plans',
              iconPath: Assets.icons.compensation.stock.path,
              description: 'Create compensation plans and salary structures for different employee groups',
              timeEstimation: '~25 mins',
              status: SetupStepStatus.locked,
              dependencies: ['Compensation Components'],
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 6,
              title: 'Approval Workflows',
              iconPath: Assets.icons.settingsIcon.path,
              description: 'Configure multi-stage approval workflows for compensation adjustments',
              timeEstimation: '~15 mins',
              status: SetupStepStatus.locked,
              dependencies: ['Compensation Plans'],
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 7,
              title: 'Payroll Integration',
              iconPath: Assets.icons.timeManagementIcon.path,
              description: 'Set up payroll transfer settings and reconciliation parameters',
              timeEstimation: '~20 mins',
              status: SetupStepStatus.locked,
              dependencies: ['Approval Workflows'],
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 8,
              title: 'Analytics & Reporting',
              iconPath: Assets.icons.analyticsIcon.path,
              description: 'Configure analytics dashboards, KPIs, and scheduled reports',
              timeEstimation: '~10 mins',
              status: SetupStepStatus.locked,
              dependencies: ['Payroll Integration'],
            ),
            Gap(16.h),
            SetupStepCard(
              stepNumber: 8,
              title: 'Security & Permissions',
              iconPath: Assets.icons.securityIcon.path,
              description: 'Define user roles, permissions, and data access controls',
              timeEstimation: '~15 mins',
              status: SetupStepStatus.locked,
              dependencies: ['Analytics & Reporting'],
            ),
          ],
        ),
      ),
    );
  }
}
