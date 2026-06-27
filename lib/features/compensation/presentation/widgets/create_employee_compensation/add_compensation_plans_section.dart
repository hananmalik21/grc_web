import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/common/app_info_tooltip.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';
import 'package:grc/features/hiring/application/offers/controllers/create_offer_provider.dart';
import 'package:grc/features/hiring/application/offers/providers/create_offer_eligible_plans_request_provider.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/providers/add_employee_compensation_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_plan_details_card.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';

class AddCompensationPlansSection extends ConsumerWidget {
  final TextEditingController planSearchController;
  final bool showEffectiveDateFields;
  final CompensationPlansSelectionNotifierProvider? plansProvider;
  final bool isAddEmployeeFlow;
  final bool isCreateOfferFlow;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;

  const AddCompensationPlansSection({
    super.key,
    required this.planSearchController,
    this.showEffectiveDateFields = true,
    this.plansProvider,
    this.isAddEmployeeFlow = false,
    this.isCreateOfferFlow = false,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  CompensationPlansSelectionNotifierProvider get _plansProvider => plansProvider ?? addCompensationPlansProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePlansProvider = _plansProvider;
    final state = ref.watch(effectivePlansProvider);
    final notifier = ref.read(effectivePlansProvider.notifier);
    final currenciesAsync = ref.watch(employeeCompensationLookupValuesProvider('CURRENCY'));
    final currencies = currenciesAsync.valueOrNull ?? const <CompLookupValue>[];
    final isMobile = context.isMobileLayout;

    final selectedCurrency = state.selectedCurrency.isEmpty
        ? null
        : currencies.where((c) => c.valueCode == state.selectedCurrency).firstOrNull;

    return Column(
      children: [
        CompensationSectionCard(
          title: 'Add Compensation Plans',
          child: Column(
            children: [
              _TopAlignedInfoBannerCard(
                iconAssetPath: Assets.icons.infoCircleBlue.path,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Type Restriction',
                      style: context.textTheme.labelMedium?.copyWith(fontSize: 13.sp, color: AppColors.primary),
                    ),
                    Gap(6.h),
                    Text(
                      'You can add multiple plans, but only one plan per type. Each plan type brings its own salary structure and components.',
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.roleActionBlue),
                    ),
                  ],
                ),
              ),
              Gap(16.h),
              Builder(
                builder: (context) {
                  if (state.eligiblePlans.isEmpty && !state.isEligiblePlansLoading) {
                    final bool awaitingPrerequisites;
                    final String hintText;

                    if (isAddEmployeeFlow) {
                      final criteria = ref.watch(addEmployeeEligiblePlansCriteriaProvider);
                      awaitingPrerequisites = criteria == null;
                      hintText = criteria == null
                          ? 'Complete assignment and job details in previous steps to see eligible plans'
                          : 'No eligible plans found for the selected criteria';
                    } else if (isCreateOfferFlow) {
                      final request = ref.watch(createOfferEligiblePlansRequestProvider);
                      awaitingPrerequisites = request == null;
                      hintText = request == null
                          ? 'Select a position in the previous step to see eligible plans'
                          : 'No eligible plans found for the selected position';
                    } else {
                      final selectedEmployee = ref.watch(
                        employeeCompensationDetailsProvider.select((s) => s.selectedEmployee),
                      );
                      awaitingPrerequisites = selectedEmployee == null;
                      hintText = selectedEmployee == null
                          ? 'Select an employee at the top to see eligible plans'
                          : 'No eligible plans found for the selected employee';
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: DigifyTextField(
                        key: const ValueKey('plan-hint'),
                        labelText: 'Compensation Plan',
                        hintText: hintText,
                        readOnly: true,
                        fillColor: awaitingPrerequisites
                            ? (context.isDark ? AppColors.inputBgDark : AppColors.tableHeaderBackground)
                            : context.themeCardBackground,
                      ),
                    );
                  }

                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DigifySelectFieldWithLabel<CompensationPlan>(
                          label: 'Compensation Plan',
                          isRequired: true,
                          value: state.selectedPlan,
                          hint: state.isEligiblePlansLoading ? 'Loading eligible plans...' : 'Select compensation plan',
                          items: state.eligiblePlans,
                          itemLabelBuilder: (item) => '${item.planCode} - ${item.planName}',
                          onChanged: (value) {
                            if (value == null) return;
                            notifier.setSelectedPlan(value);
                          },
                        ),
                        Gap(12.h),
                        Builder(
                          builder: (ctx) {
                            final alreadyAdded =
                                state.selectedPlan != null &&
                                state.addedPlans.any((p) => p.planId == state.selectedPlan!.planId);
                            final disabled = state.isEligiblePlansLoading || state.selectedPlan == null || alreadyAdded;
                            return AppButton.primary(
                              label: 'Add Plan',
                              svgPath: Assets.icons.addDivisionIcon.path,
                              onPressed: disabled
                                  ? null
                                  : () {
                                      notifier.addSelectedPlan();
                                      ToastService.success(ctx, '${state.selectedPlan!.planName} added successfully');
                                    },
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DigifySelectFieldWithLabel<CompensationPlan>(
                          label: 'Compensation Plan',
                          isRequired: true,
                          value: state.selectedPlan,
                          hint: state.isEligiblePlansLoading ? 'Loading eligible plans...' : 'Select compensation plan',
                          items: state.eligiblePlans,
                          itemLabelBuilder: (item) => '${item.planCode} - ${item.planName}',
                          onChanged: (value) {
                            if (value == null) return;
                            notifier.setSelectedPlan(value);
                          },
                        ),
                      ),
                      Gap(12.w),
                      Builder(
                        builder: (ctx) {
                          final alreadyAdded =
                              state.selectedPlan != null &&
                              state.addedPlans.any((p) => p.planId == state.selectedPlan!.planId);
                          final disabled = state.isEligiblePlansLoading || state.selectedPlan == null || alreadyAdded;
                          return AppButton.primary(
                            label: 'Add Plan',
                            svgPath: Assets.icons.addDivisionIcon.path,
                            onPressed: disabled
                                ? null
                                : () {
                                    notifier.addSelectedPlan();
                                    ToastService.success(ctx, '${state.selectedPlan!.planName} added successfully');
                                  },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final currencyField = DigifySelectFieldWithLabel<CompLookupValue>(
                    label: 'Currency',
                    isRequired: true,
                    value: selectedCurrency,
                    hint: currenciesAsync.isLoading ? 'Please wait...' : 'Select currency',
                    items: currencies,
                    itemLabelBuilder: (item) => '${item.valueCode} - ${item.valueName}',
                    onChanged: (value) {
                      if (value == null) return;
                      notifier.setSelectedCurrency(value.valueCode);
                    },
                  );

                  if (showEffectiveDateFields) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Gap(16.h),
                        ..._buildEffectiveDateFields(
                          context: context,
                          state: state,
                          notifier: notifier,
                          isMobile: isMobile,
                          currencyField: currencyField,
                          isStartDateLocked: isAddEmployeeFlow || isCreateOfferFlow,
                          lockedStartDate: isAddEmployeeFlow
                              ? ref.watch(addEmployeeAssignmentProvider.select((s) => s.asgStart))
                              : isCreateOfferFlow
                              ? ref.watch(createOfferProvider.select((s) => s.proposedStartDate))
                              : null,
                          hireDate: isAddEmployeeFlow
                              ? (ref.watch(addEmployeeAssignmentProvider.select((s) => s.asgStart)) ??
                                    ref.watch(addEmployeeJobEmploymentProvider.select((s) => s.enterpriseHireDate)))
                              : isCreateOfferFlow
                              ? ref.watch(createOfferProvider.select((s) => s.proposedStartDate))
                              : ref.watch(employeeCompensationDetailsProvider.select((s) => s.enterpriseHireDate)),
                          startDateLabel: isAddEmployeeFlow
                              ? AppLocalizations.of(context)!.compensationStartDate
                              : isCreateOfferFlow
                              ? 'Proposed Start Date'
                              : 'Effective Start Date',
                          endDateLabel: isAddEmployeeFlow
                              ? AppLocalizations.of(context)!.compensationEndDate
                              : 'Effective End Date',
                          dateHint: AppLocalizations.of(context)!.hintSelectDate,
                        ),
                      ],
                    );
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Gap(16.h), currencyField]);
                },
              ),
            ],
          ),
        ),
        if (state.addedPlans.isNotEmpty) ...[
          Gap(24.h),
          ...state.addedPlansWithEarningFirst.map(
            (plan) => Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: CompensationPlanDetailsCard(
                key: ValueKey('details-${plan.planId}'),
                plan: plan,
                plansProvider: effectivePlansProvider,
                budgetedMinKd: budgetedMinKd,
                budgetedMaxKd: budgetedMaxKd,
                onRemove: () => notifier.removePlan(plan),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

List<Widget> _buildEffectiveDateFields({
  required BuildContext context,
  required AddCompensationPlansState state,
  required CompensationPlansSelectionNotifier notifier,
  required bool isMobile,
  required Widget currencyField,
  required bool isStartDateLocked,
  required DateTime? lockedStartDate,
  required DateTime? hireDate,
  required String startDateLabel,
  required String endDateLabel,
  required String dateHint,
}) {
  final fillColor = context.themeCardBackground;
  final compensationStartDate = isStartDateLocked ? lockedStartDate : state.effectiveDate;
  final hireDateStr = hireDate != null ? DateFormat('dd/MM/yyyy').format(hireDate) : null;
  if (isMobile) {
    return [
      DigifyDateField(
        label: startDateLabel,
        isRequired: true,
        hintText: dateHint,
        initialDate: compensationStartDate,
        firstDate: hireDate,
        lastDate: DateTime(2100, 12, 31),
        readOnly: isStartDateLocked,
        onDateSelected: isStartDateLocked ? null : notifier.setEffectiveDate,
        fillColor: fillColor,
        suffixIcon: isStartDateLocked
            ? (hireDateStr != null ? AppInfoTooltip(message: 'Same as assignment start date ($hireDateStr)') : null)
            : hireDate != null
            ? AppInfoTooltip(
                message: 'Compensation start date must be on or after the assignment start date ($hireDateStr)',
              )
            : null,
      ),
      Gap(16.h),
      DigifyDateField(
        label: endDateLabel,
        isRequired: false,
        hintText: dateHint,
        initialDate: state.endDate,
        firstDate: compensationStartDate,
        lastDate: DateTime(2100, 12, 31),
        onDateSelected: notifier.setEndDate,
        readOnly: compensationStartDate == null,
        fillColor: fillColor,
      ),
      Gap(16.h),
      currencyField,
    ];
  }

  return [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DigifyDateField(
            label: startDateLabel,
            isRequired: true,
            hintText: dateHint,
            initialDate: compensationStartDate,
            firstDate: hireDate,
            lastDate: DateTime(2100, 12, 31),
            readOnly: isStartDateLocked,
            onDateSelected: isStartDateLocked ? null : notifier.setEffectiveDate,
            fillColor: fillColor,
            suffixIcon: isStartDateLocked
                ? (hireDateStr != null ? AppInfoTooltip(message: 'Same as assignment start date ($hireDateStr)') : null)
                : hireDate != null
                ? AppInfoTooltip(
                    message: 'Compensation start date must be on or after the assignment start date ($hireDateStr)',
                  )
                : null,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: DigifyDateField(
            label: endDateLabel,
            isRequired: false,
            hintText: dateHint,
            initialDate: state.endDate,
            firstDate: compensationStartDate,
            lastDate: DateTime(2100, 12, 31),
            onDateSelected: notifier.setEndDate,
            readOnly: compensationStartDate == null,
            fillColor: fillColor,
          ),
        ),
        Gap(16.w),
        Expanded(child: currencyField),
      ],
    ),
  ];
}

class _TopAlignedInfoBannerCard extends StatelessWidget {
  final String iconAssetPath;
  final Widget child;

  const _TopAlignedInfoBannerCard({required this.iconAssetPath, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: DigifyAsset(
              assetPath: iconAssetPath,
              width: 20,
              height: 20,
              color: isDark ? AppColors.primaryDark : AppColors.primary,
            ),
          ),
          Gap(8.w),
          Expanded(child: child),
        ],
      ),
    );
  }
}
