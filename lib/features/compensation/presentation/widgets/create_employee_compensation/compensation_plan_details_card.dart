import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/common/range_warning_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailsCard extends ConsumerWidget {
  final CompensationPlan plan;
  final VoidCallback? onRemove;
  final CompensationPlansSelectionNotifierProvider? plansProvider;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;

  const CompensationPlanDetailsCard({
    super.key,
    required this.plan,
    this.onRemove,
    this.plansProvider,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  CompensationPlansSelectionNotifierProvider get _plansProvider => plansProvider ?? addCompensationPlansProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final effectivePlansProvider = _plansProvider;
    final groupedComponents = ref.watch(
      effectivePlansProvider.select((s) => s.groupedEffectiveComponentsForPlan(plan)),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.planName.isNotEmpty ? plan.planName : 'Compensation Plan',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        plan.displaySalaryStructureList.isNotEmpty
                            ? plan.displaySalaryStructureList.join(', ')
                            : plan.planCode,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? context.themeTextMuted : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRemove != null)
                  AppButton.dangerOutline(
                    label: 'Remove',
                    onPressed: onRemove,
                    svgPath: Assets.icons.deleteIconRed.path,
                  ),
              ],
            ),
          ),

          DigifyDivider.horizontal(),

          if (groupedComponents.isEmpty)
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                'No components available for this plan.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? context.themeTextMuted : AppColors.textSecondary,
                ),
              ),
            )
          else ...[
            for (var i = 0; i < groupedComponents.keys.length; i++) ...[
              if (i > 0) DigifyDivider.horizontal(),
              _buildComponentSection(
                context,
                planId: plan.planId,
                title: groupedComponents.keys.elementAt(i),
                components: groupedComponents.values.elementAt(i),
                plansProvider: effectivePlansProvider,
                budgetedMinKd: budgetedMinKd,
                budgetedMaxKd: budgetedMaxKd,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildComponentSection(
    BuildContext context, {
    required int planId,
    required String title,
    required List<PlanComponent> components,
    required CompensationPlansSelectionNotifierProvider plansProvider,
    double? budgetedMinKd,
    double? budgetedMaxKd,
  }) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),

          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: components.map((comp) {
              return SizedBox(
                width: 400.w,
                child: _ComponentInputField(
                  key: ValueKey('comp-${plan.planId}-${comp.componentId}'),
                  planId: plan.planId,
                  comp: comp,
                  plansProvider: plansProvider,
                  budgetedMinKd: budgetedMinKd,
                  budgetedMaxKd: budgetedMaxKd,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ComponentInputField extends ConsumerStatefulWidget {
  final int planId;
  final PlanComponent comp;
  final CompensationPlansSelectionNotifierProvider plansProvider;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;

  const _ComponentInputField({
    required this.planId,
    required this.comp,
    required this.plansProvider,
    this.budgetedMinKd,
    this.budgetedMaxKd,
    required Key key,
  }) : super(key: key);

  @override
  ConsumerState<_ComponentInputField> createState() => _ComponentInputFieldState();
}

class _ComponentInputFieldState extends ConsumerState<_ComponentInputField> {
  late final TextEditingController _controller;
  String? _warningMessage;

  @override
  void initState() {
    super.initState();
    final amount = ref.read(widget.plansProvider).amountFor(widget.planId, widget.comp.componentId);
    _controller = TextEditingController(text: amount > 0 ? amount.toStringAsFixed(0) : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value, {double? budgetedMin, double? budgetedMax}) {
    final notifier = ref.read(widget.plansProvider.notifier);
    notifier.setAmount(widget.planId, widget.comp.componentId, value);

    final amount = double.tryParse(value);
    String? warning;
    if (amount != null && amount > 0) {
      if (budgetedMin != null && amount < budgetedMin) {
        warning = 'Amount is below the minimum budget of ${budgetedMin.toStringAsFixed(0)} KD';
      } else if (budgetedMax != null && amount > budgetedMax) {
        warning = 'Amount exceeds the maximum budget of ${budgetedMax.toStringAsFixed(0)} KD';
      }
    }
    if (warning != _warningMessage) {
      setState(() => _warningMessage = warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final comp = widget.comp;
    final isEarning = (comp.component?.categoryCode ?? '').toUpperCase() == 'EARNING';
    final empDetails = ref.watch(employeeCompensationDetailsProvider);
    final budgetedMin = isEarning ? (widget.budgetedMinKd ?? empDetails.budgetedMinKd) : null;
    final budgetedMax = isEarning ? (widget.budgetedMaxKd ?? empDetails.budgetedMaxKd) : null;

    final inputFormatters = <TextInputFormatter>[
      AppInputFormatters.digitsOnly,
      if (budgetedMax != null) AppInputFormatters.maxValue(budgetedMax),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          controller: _controller,
          labelText: comp.component!.displayName.toUpperCase(),
          isRequired: comp.isMandatory,
          hintText: isEarning && budgetedMin != null && budgetedMax != null
              ? '${budgetedMin.toStringAsFixed(0)} – ${budgetedMax.toStringAsFixed(0)}'
              : '0.00',
          fillColor: context.themeCardBackground,
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          onChanged: (v) => _onChanged(v, budgetedMin: budgetedMin, budgetedMax: budgetedMax),
        ),
        if (isEarning && budgetedMin != null && budgetedMax != null) ...[
          Gap(4.h),
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 12.w, color: AppColors.grayBorderDark),
              Gap(4.w),
              Text(
                'Allowed range: ${budgetedMin.toStringAsFixed(0)} – ${budgetedMax.toStringAsFixed(0)} KD',
                style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: AppColors.grayBorderDark),
              ),
            ],
          ),
        ],
        if (_warningMessage != null) ...[Gap(6.h), RangeWarningCard(message: _warningMessage!)],
        if (comp.component?.calculationMethod != null &&
            comp.component!.calculationMethod.trim().isNotEmpty &&
            comp.component!.calculationMethod != '---') ...[
          Gap(6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(Icons.calculate_outlined, size: 14.w, color: const Color(0xFF2C5EE4)),
              ),
              Gap(6.w),
              Expanded(
                child: Text(
                  'Calculated as ${comp.component!.calculationMethod}',
                  style: context.textTheme.labelSmall?.copyWith(color: const Color(0xFF2C5EE4), fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
