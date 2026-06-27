import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustment_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_component_employee_preview_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkComponentAdjustmentCard extends ConsumerWidget {
  const BulkComponentAdjustmentCard({super.key, required this.group, required this.isDark});

  final BulkComponentAdjustmentGroup group;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final adjustmentMethodAsync = ref.watch(bulkAdjustmentMethodLookupProvider);
    final formNotifier = ref.read(bulkAdjustmentsFormProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.componentName,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(4.h),
          Text(
            group.componentCode,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
          Gap(16.h),
          _SharedAdjustmentBlock(
            group: group,
            isDark: isDark,
            localizations: localizations,
            adjustmentMethodAsync: adjustmentMethodAsync,
            onAdjustmentTypeChanged: (value) {
              if (value == null) return;
              formNotifier.applyToAllEmployees(group.componentId, adjustmentType: value);
            },
            onValueChanged: (value) {
              formNotifier.applyToAllEmployees(group.componentId, value: value);
            },
          ),
          Gap(16.h),
          _EmployeePreviewList(group: group, isDark: isDark, localizations: localizations),
          Gap(16.h),
          AppButton.text(
            label: localizations.compensationAdjustmentRemoveComponent,
            onPressed: () => formNotifier.removeComponentGroup(group.componentId),
            svgAssetColor: AppColors.alertCritical,
            foregroundColor: AppColors.alertCritical,
            svgPath: Assets.icons.deleteIconRed.path,
          ),
        ],
      ),
    );
  }
}

class _SharedAdjustmentBlock extends StatelessWidget {
  const _SharedAdjustmentBlock({
    required this.group,
    required this.isDark,
    required this.localizations,
    required this.adjustmentMethodAsync,
    required this.onAdjustmentTypeChanged,
    required this.onValueChanged,
  });

  final BulkComponentAdjustmentGroup group;
  final bool isDark;
  final AppLocalizations localizations;
  final AsyncValue<List<CompLookupValue>> adjustmentMethodAsync;
  final ValueChanged<String?> onAdjustmentTypeChanged;
  final ValueChanged<String> onValueChanged;

  @override
  Widget build(BuildContext context) {
    final methodSection = adjustmentMethodAsync.when(
      data: (methods) => _buildAdjustmentMethodField(methods),
      loading: () => _buildAdjustmentMethodLoadingField(),
      error: (_, _) => _buildAdjustmentMethodLoadingField(),
    );

    final valueSection = DigifyTextField(
      key: ValueKey('bulk_shared_value_${group.componentId}_${group.sharedAdjustmentType}'),
      labelText: localizations.compensationAdjustmentValueLabel,
      hintText: _buildValueHint(group.sharedAdjustmentType, group.currencyCode),
      initialValue: group.sharedValue,
      onChanged: onValueChanged,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.bulkAdjustmentsApplyToAllTitle,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          if (context.isMobileLayout) ...[
            methodSection,
            Gap(16.h),
            valueSection,
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: methodSection),
                Gap(12.w),
                Expanded(child: valueSection),
              ],
            ),
          ],
          if (group.showManualUniformAmountHint) ...[
            Gap(12.h),
            Text(
              localizations.bulkAdjustmentsManualUniformAmountHint,
              style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdjustmentMethodField(List<CompLookupValue> methods) {
    return DigifySelectFieldWithLabel<String>(
      label: localizations.compensationAdjustmentTypeLabel,
      value: methods.any((method) => method.valueCode == group.sharedAdjustmentType)
          ? group.sharedAdjustmentType
          : null,
      items: methods.map((method) => method.valueCode).toList(),
      itemLabelBuilder: (code) => methods.firstWhere((method) => method.valueCode == code).valueName,
      onChanged: onAdjustmentTypeChanged,
    );
  }

  Widget _buildAdjustmentMethodLoadingField() {
    return DigifySelectFieldWithLabel<String>(
      label: localizations.compensationAdjustmentTypeLabel,
      items: const [],
      itemLabelBuilder: (value) => value,
      hint: localizations.compensationAdjustmentMethodLoading,
      onChanged: null,
    );
  }

  String _buildValueHint(String methodCode, String currencyCode) {
    return switch (AdjustmentMethod.fromCode(methodCode)) {
      AdjustmentMethod.percentage => localizations.compensationAdjustmentValueHintPercentage,
      AdjustmentMethod.amount ||
      AdjustmentMethod.manual => localizations.compensationAdjustmentValueHintCurrency(currencyCode),
      null => localizations.compensationAdjustmentValueHintDefault,
    };
  }
}

class _EmployeePreviewList extends StatefulWidget {
  const _EmployeePreviewList({required this.group, required this.isDark, required this.localizations});

  final BulkComponentAdjustmentGroup group;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  State<_EmployeePreviewList> createState() => _EmployeePreviewListState();
}

class _EmployeePreviewListState extends State<_EmployeePreviewList> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.group.employeeEdits.length <= BulkAdjustmentCardConfig.collapseBreakdownThreshold;
  }

  @override
  void didUpdateWidget(covariant _EmployeePreviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.group.employeeEdits.length != widget.group.employeeEdits.length) {
      _isExpanded = widget.group.employeeEdits.length <= BulkAdjustmentCardConfig.collapseBreakdownThreshold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final edits = widget.group.employeeEdits;
    final count = edits.length;
    final shouldCollapse = count > BulkAdjustmentCardConfig.collapseBreakdownThreshold;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: shouldCollapse ? () => setState(() => _isExpanded = !_isExpanded) : null,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.localizations.bulkAdjustmentsEmployeeBreakdownTitle,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  widget.localizations.bulkAdjustmentsEmployeeBreakdownCount(count),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                ),
                if (shouldCollapse) ...[
                  Gap(8.w),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!shouldCollapse || _isExpanded) ...[
          Gap(8.h),
          if (!context.isMobileLayout)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.localizations.bulkAdjustmentsPreviewEmployeeColumn,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.localizations.bulkAdjustmentsPreviewCurrentColumn,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.localizations.compensationAdjustmentNewAmountLabel,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: edits.length,
            itemBuilder: (context, index) {
              return BulkComponentEmployeePreviewRow(
                key: ValueKey('preview_${widget.group.componentId}_${edits[index].employeeGuid}'),
                edit: edits[index],
                isDark: widget.isDark,
                localizations: widget.localizations,
              );
            },
          ),
        ],
      ],
    );
  }
}
