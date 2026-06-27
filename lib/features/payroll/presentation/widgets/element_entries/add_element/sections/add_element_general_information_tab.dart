import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/app_info_tooltip.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_switch_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/element_entries/config/add_element_form_config.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_floating_amount_field.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_lookup_select_field.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_nested_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddElementGeneralInformationTab extends StatelessWidget {
  const AddElementGeneralInformationTab({
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.creatorType,
    required this.processed,
    required this.retroactiveEntry,
    required this.automaticEntry,
    required this.sequenceNumber,
    required this.reason,
    required this.payValue,
    required this.amount,
    required this.contextSegment,
    required this.onEffectiveStartDateSelected,
    required this.onEffectiveEndDateSelected,
    required this.onCreatorTypeChanged,
    required this.onProcessedChanged,
    required this.onRetroactiveChanged,
    required this.onAutomaticChanged,
    required this.onSequenceNumberChanged,
    required this.onReasonChanged,
    required this.onPayValueChanged,
    required this.onAmountChanged,
    required this.onContextSegmentChanged,
    super.key,
  });

  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String? creatorType;
  final bool processed;
  final bool retroactiveEntry;
  final bool automaticEntry;
  final String sequenceNumber;
  final String reason;
  final String payValue;
  final String amount;
  final String? contextSegment;
  final ValueChanged<DateTime> onEffectiveStartDateSelected;
  final ValueChanged<DateTime> onEffectiveEndDateSelected;
  final ValueChanged<String?> onCreatorTypeChanged;
  final ValueChanged<bool> onProcessedChanged;
  final ValueChanged<bool> onRetroactiveChanged;
  final ValueChanged<bool> onAutomaticChanged;
  final ValueChanged<String> onSequenceNumberChanged;
  final ValueChanged<String> onReasonChanged;
  final ValueChanged<String> onPayValueChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String?> onContextSegmentChanged;

  static const int _rowColumns = 3;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddElementFormRow(
          columns: _rowColumns,
          children: [
            DigifyDateField(
              label: loc.payrollAddElementEffectiveStartDate,
              isRequired: true,
              hintText: loc.payrollAddElementDateHint,
              initialDate: effectiveStartDate,
              onDateSelected: onEffectiveStartDateSelected,
            ),
            DigifyDateField(
              label: loc.payrollAddElementEffectiveEndDate,
              isRequired: false,
              hintText: loc.payrollAddElementDateHint,
              initialDate: effectiveEndDate,
              onDateSelected: onEffectiveEndDateSelected,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollAddElementCreatorType,
              value: creatorType,
              items: AddElementFormConfig.creatorTypeOptions,
              itemLabelBuilder: (value) => value,
              onChanged: onCreatorTypeChanged,
            ),
          ],
        ),
        Gap(16.h),
        AddElementFormRow(
          columns: _rowColumns,
          children: [
            DigifySwitchFieldWithLabel(
              label: loc.payrollAddElementProcessed,
              value: processed,
              onChanged: onProcessedChanged,
            ),
            DigifySwitchFieldWithLabel(
              label: loc.payrollAddElementRetroactiveEntry,
              value: retroactiveEntry,
              onChanged: onRetroactiveChanged,
            ),
            DigifySwitchFieldWithLabel(
              label: loc.payrollAddElementAutomaticEntry,
              value: automaticEntry,
              onChanged: onAutomaticChanged,
            ),
          ],
        ),
        Gap(16.h),
        AddElementFormRow(
          columns: _rowColumns,
          children: [
            DigifyTextField(
              initialValue: sequenceNumber,
              labelText: loc.payrollAddElementSequenceNumber,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              filled: true,
              onChanged: onSequenceNumberChanged,
            ),
          ],
        ),
        Gap(16.h),
        DigifyTextArea(
          initialValue: reason,
          labelText: loc.payrollAddElementReason,
          hintText: loc.payrollAddElementReasonHint,
          maxLines: 4,
          minLines: 3,
          onChanged: onReasonChanged,
        ),
        Gap(24.h),
        AddElementNestedSection(
          title: loc.payrollAddElementEntryValues,
          trailing: AppInfoTooltip(message: loc.payrollAddElementEntryValuesTooltip),
          child: AddElementFormRow(
            columns: 2,
            children: [
              AddElementFloatingAmountField(
                label: loc.payrollAddElementPayValue,
                hintText: loc.payrollAddElementPayValueHint,
                value: payValue,
                onChanged: onPayValueChanged,
              ),
              AddElementFloatingAmountField(
                label: loc.payrollAddElementAmount,
                hintText: loc.payrollAddElementAmountHint,
                value: amount,
                isRequired: true,
                onChanged: onAmountChanged,
              ),
            ],
          ),
        ),
        Gap(24.h),
        AddElementNestedSection(
          title: loc.payrollAddElementExtraDetails,
          child: AddElementFormRow(
            columns: _rowColumns,
            children: [
              AddElementLookupSelectField(
                label: loc.payrollAddElementContextSegment,
                typeCode: PayLookupTypeCode.contextSegment,
                value: contextSegment,
                onChanged: onContextSegmentChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
