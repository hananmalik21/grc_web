import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustment_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_metadata_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkAdjustmentDetailsSection extends ConsumerWidget {
  const BulkAdjustmentDetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final metadata = ref.watch(bulkAdjustmentsMetadataProvider);
    final metadataNotifier = ref.read(bulkAdjustmentsMetadataProvider.notifier);
    final reasonCodesAsync = ref.watch(bulkReasonCodeLookupProvider);
    final budgetCodesAsync = ref.watch(bulkBudgetCodeLookupProvider);

    return Container(
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
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.calculator.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Text(
                localizations.bulkAdjustmentsDetailsSectionTitle,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(24.h),
          if (context.isMobileLayout) ...[
            DigifyDateField(
              label: localizations.bulkAdjustmentsEffectiveDateLabel,
              isRequired: true,
              hintText: localizations.bulkAdjustmentsEffectiveDateHint,
              initialDate: metadata.effectiveDate,
              lastDate: DateTime(DateTime.now().year + 5),
              onDateSelected: metadataNotifier.setEffectiveDate,
            ),
            Gap(16.h),
            _LookupField(
              label: localizations.bulkAdjustmentsReasonCodeLabel,
              asyncValue: reasonCodesAsync,
              currentValue: metadata.reasonCode.isEmpty ? null : metadata.reasonCode,
              hint: localizations.bulkAdjustmentsSelectReasonCode,
              onChanged: metadataNotifier.setReasonCode,
            ),
            Gap(16.h),
            _LookupField(
              label: localizations.bulkAdjustmentsBudgetCodeLabel,
              asyncValue: budgetCodesAsync,
              currentValue: metadata.budgetCode.isEmpty ? null : metadata.budgetCode,
              hint: localizations.bulkAdjustmentsSelectBudgetCode,
              onChanged: metadataNotifier.setBudgetCode,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DigifyDateField(
                    label: localizations.bulkAdjustmentsEffectiveDateLabel,
                    isRequired: true,
                    hintText: localizations.bulkAdjustmentsEffectiveDateHint,
                    initialDate: metadata.effectiveDate,
                    lastDate: DateTime(DateTime.now().year + 5),
                    onDateSelected: metadataNotifier.setEffectiveDate,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: _LookupField(
                    label: localizations.bulkAdjustmentsReasonCodeLabel,
                    asyncValue: reasonCodesAsync,
                    currentValue: metadata.reasonCode.isEmpty ? null : metadata.reasonCode,
                    hint: localizations.bulkAdjustmentsSelectReasonCode,
                    onChanged: metadataNotifier.setReasonCode,
                  ),
                ),
              ],
            ),
            Gap(24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _LookupField(
                    label: localizations.bulkAdjustmentsBudgetCodeLabel,
                    asyncValue: budgetCodesAsync,
                    currentValue: metadata.budgetCode.isEmpty ? null : metadata.budgetCode,
                    hint: localizations.bulkAdjustmentsSelectBudgetCode,
                    onChanged: metadataNotifier.setBudgetCode,
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
          Gap(24.h),
          DigifyTextArea(
            labelText: localizations.bulkAdjustmentsJustificationLabel,
            isRequired: true,
            hintText: localizations.bulkAdjustmentsJustificationHint,
            initialValue: metadata.justification,
            onChanged: metadataNotifier.setJustification,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _LookupField extends StatelessWidget {
  const _LookupField({
    required this.label,
    required this.asyncValue,
    required this.currentValue,
    required this.hint,
    required this.onChanged,
  });

  final String label;
  final AsyncValue<List<CompLookupValue>> asyncValue;
  final String? currentValue;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (items) => DigifySelectFieldWithLabel<String>(
        label: label,
        value: items.any((item) => item.valueCode == currentValue) ? currentValue : null,
        items: items.map((item) => item.valueCode).toList(),
        itemLabelBuilder: (code) => items.firstWhere((item) => item.valueCode == code).valueName,
        isRequired: true,
        hint: hint,
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
      loading: () => DigifySelectFieldWithLabel<String>(
        label: label,
        items: const [],
        itemLabelBuilder: _dummyLabelBuilder,
        isRequired: true,
        hint: hint,
      ),
      error: (_, _) => DigifySelectFieldWithLabel<String>(
        label: label,
        items: const [],
        itemLabelBuilder: _dummyLabelBuilder,
        isRequired: true,
        hint: hint,
      ),
    );
  }

  static String _dummyLabelBuilder(String value) => value;
}
