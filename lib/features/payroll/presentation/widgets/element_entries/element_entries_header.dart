import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/payroll/domain/models/element_entry_employee_context.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_employee_switcher.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_header_actions.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_info_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesHeader extends ConsumerWidget {
  const ElementEntriesHeader({this.showSwitcher = true, this.customActions, super.key});

  final bool showSwitcher;
  final Widget? customActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final selectedEmployee = ref.watch(elementEntriesTabProvider.select((s) => s.selectedEmployee));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedEmployee != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _EmployeeIdentitySection(employee: selectedEmployee)),
                Gap(18.w),
                customActions ?? const ElementEntriesHeaderActions(),
              ],
            ),
            if (showSwitcher) DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
          ],
          if (showSwitcher) const ElementEntriesEmployeeSwitcher(),
        ],
      ),
    );
  }
}

class ElementEntriesHeaderMobile extends ConsumerWidget {
  const ElementEntriesHeaderMobile({this.showSwitcher = true, this.customActions, super.key});

  final bool showSwitcher;
  final Widget? customActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final selectedEmployee = ref.watch(elementEntriesTabProvider.select((s) => s.selectedEmployee));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedEmployee != null) ...[
            _EmployeeIdentitySection(employee: selectedEmployee, compact: true),
            Gap(12.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: customActions ?? const ElementEntriesHeaderActions(compact: true),
            ),
            if (showSwitcher) DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
          ],
          if (showSwitcher) const ElementEntriesEmployeeSwitcher(),
        ],
      ),
    );
  }
}

class _EmployeeIdentitySection extends StatelessWidget {
  const _EmployeeIdentitySection({required this.employee, this.compact = false});

  final ElementEntryEmployeeContext employee;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark;
    final avatarSize = compact ? 52.w : 68.w;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(fallbackInitial: employee.employeeName, size: avatarSize),
        Gap(compact ? 12.w : 18.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.employeeName,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: compact ? 18.sp : 21.sp,
                  color: textPrimary,
                ),
                maxLines: compact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(3.h),
              Text(
                employee.departmentLine,
                style: context.textTheme.titleSmall?.copyWith(fontSize: 13.sp, color: textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(7.h),
              ElementEntriesInfoPills(
                personNumber: employee.personNumber,
                payrollRelationship: employee.payrollRelationship,
                assignmentNumber: employee.assignmentNumber,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
