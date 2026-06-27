import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/compensation_plans_selection_notifier.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/add_compensation_plans_section.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_calculator_sidebar.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/providers/add_employee_compensation_providers.dart';
import 'package:grc/features/employee_management/presentation/navigation/edit_employee_salary_adjustment_navigation.dart'
    show EditEmployeeSalaryAdjustmentOutcome, openEditEmployeeSalaryAdjustment;
import 'package:grc/features/employee_management/application/edit_employee_compensation/providers/edit_employee_assigned_components_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_editing_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/edit_employee_assigned_components_section.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeCompensationStep extends ConsumerWidget {
  const AddEmployeeCompensationStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(addEmployeeEditingEmployeeIdProvider) != null;
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    if (isEditing) {
      return _EditEmployeeCompensationStep(localizations: localizations, iconAssetPath: em.compensation.path);
    }

    ref.watch(addEmployeeCompensationProvider);
    ref.watch(addEmployeeAssignmentProvider.select((s) => s.asgStart));
    final formController = ref.watch(addEmployeeCompensationFormControllerProvider);
    final position = ref.watch(addEmployeeJobEmploymentProvider.select((s) => s.selectedPosition));
    final budgetedMin = CompensationPlansSelectionNotifier.parseBudget(position?.budgetedMin);
    final budgetedMax = CompensationPlansSelectionNotifier.parseBudget(position?.budgetedMax);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.compensation.path,
          title: localizations.compensationAndBenefits,
          subtitle: localizations.compensationAndBenefitsSubtitle,
        ),
        Builder(
          builder: (context) {
            final isTwoColumn = context.isDesktopLayout;

            final plansColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddCompensationPlansSection(
                  planSearchController: formController.planSearchController,
                  showEffectiveDateFields: true,
                  isAddEmployeeFlow: true,
                  plansProvider: addEmployeeCompensationProvider,
                  budgetedMinKd: budgetedMin,
                  budgetedMaxKd: budgetedMax,
                ),
                Gap(24.h),
              ],
            );

            final calculatorColumn = CompensationCalculatorSidebar(
              showActions: false,
              plansProvider: addEmployeeCompensationProvider,
            );

            if (!isTwoColumn) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [plansColumn, calculatorColumn]);
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: plansColumn),
                Gap(24.w),
                Expanded(flex: 1, child: calculatorColumn),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _EditEmployeeCompensationStep extends ConsumerWidget {
  const _EditEmployeeCompensationStep({required this.localizations, required this.iconAssetPath});

  final AppLocalizations localizations;
  final String iconAssetPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final employeeGuid = ref.watch(addEmployeeEditingEmployeeIdProvider);
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final canCreateAdjustment = PermissionService.instance.can(PermKeys.compensationAdjustmentsCreate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: iconAssetPath,
          title: localizations.compensationAndBenefits,
          subtitle: localizations.editEmployeeCompensationSubtitle,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.editEmployeeCompensationDescription,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              if (canCreateAdjustment) ...[
                Gap(24.h),
                AppButton.primary(
                  label: localizations.editEmployeeOpenSalaryAdjustment,
                  onPressed: employeeGuid == null || employeeGuid.isEmpty || enterpriseId == null
                      ? null
                      : () async {
                          final outcome = await openEditEmployeeSalaryAdjustment(
                            employeeGuid: employeeGuid,
                            enterpriseId: enterpriseId,
                            context: context,
                          );
                          if (!context.mounted) return;
                          if (outcome == EditEmployeeSalaryAdjustmentOutcome.completed) {
                            ToastService.success(context, localizations.editEmployeeSalaryAdjustmentSuccess);
                            await ref.read(editEmployeeAssignedComponentsProvider(employeeGuid).notifier).refresh();
                          }
                        },
                ),
              ],
            ],
          ),
        ),
        if (employeeGuid != null && employeeGuid.isNotEmpty)
          EditEmployeeAssignedComponentsSection(employeeGuid: employeeGuid),
      ],
    );
  }
}
