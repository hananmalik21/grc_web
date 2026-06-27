import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_selection_field_with_label.dart';
import '../../../providers/lookups/manage_salary_structure_lookups_provider.dart';
import '../../../providers/salary_structure_scope_selection_providers.dart';
import '../../../providers/salary_structure_creation_provider.dart';
import 'scope_assignment_picker_mixin.dart';
import 'scope_org_structure_section.dart';

class ScopeAssignmentStep extends ConsumerStatefulWidget {
  const ScopeAssignmentStep({super.key});

  @override
  ConsumerState<ScopeAssignmentStep> createState() => _ScopeAssignmentStepState();
}

class _ScopeAssignmentStepState extends ConsumerState<ScopeAssignmentStep>
    with ScopeAssignmentPickerMixin<ScopeAssignmentStep> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final creationState = ref.watch(salaryStructureCreationProvider);
    final creationNotifier = ref.read(salaryStructureCreationProvider.notifier);
    ref.watch(salaryStructureJobFamilyNotifierProvider);
    ref.watch(salaryStructurePositionNotifierProvider);
    ref.watch(salaryStructureGradeNotifierProvider);

    final countryDropdown = ref.watch(manageSalaryStructureCountryDropdownProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.h,
                children: [
                  Text('Scope & Assignment', style: context.textTheme.titleMedium),
                  Text(
                    'Define country, job classification, and eligibility criteria',
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
              Gap(18.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.h,
                children: [
                  DigifySelectFieldWithLabel<String>(
                    label: 'Country',
                    isRequired: true,
                    items: countryDropdown.items,
                    hint: countryDropdown.hint,
                    value: creationState.country,
                    itemLabelBuilder: countryDropdown.labelFor,
                    onChanged: (value) => creationNotifier.updateScopeAndAssignment(country: value),
                  ),
                  Text('Geographic location for this structure', style: context.textTheme.labelSmall),
                ],
              ),
              Gap(18.h),
              DigifyMultiSelectFieldWithLabel(
                label: 'Job Family',
                hint: 'Add Job Family',
                selectedCount: creationState.jobFamilyIds.length,
                onTap: pickJobFamily,
                isEnabled: true,
              ),
              Gap(18.h),
              DigifyMultiSelectFieldWithLabel(
                label: 'Position',
                hint: 'Add Position',
                selectedCount: creationState.positionIds.length,
                onTap: pickPosition,
                isEnabled: true,
              ),
              Gap(18.h),
              DigifyMultiSelectFieldWithLabel(
                label: 'Grade',
                hint: 'Add Grade',
                selectedCount: creationState.gradeIds.length,
                onTap: pickGrade,
                isEnabled: true,
              ),
              Gap(18.h),
              DigifyMultiSelectFieldWithLabel(
                label: 'Contract Type',
                hint: 'Add Contract Type',
                selectedCount: creationState.contractTypes.length,
                onTap: pickContractTypes,
                isEnabled: true,
              ),
            ],
          ),
        ),
        Gap(18.h),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.h,
                children: [
                  Text('Organization & Structure', style: context.textTheme.titleMedium),
                  Text('Configure company and organizational hierarchy levels', style: context.textTheme.labelSmall),
                ],
              ),
              Gap(18.h),
              const ScopeOrgStructureSection(),
            ],
          ),
        ),
      ],
    );
  }
}
