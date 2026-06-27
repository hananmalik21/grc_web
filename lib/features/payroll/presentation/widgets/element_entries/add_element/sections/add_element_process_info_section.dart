import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_lookup_select_field.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_section_card.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddElementProcessInfoSection extends StatelessWidget {
  const AddElementProcessInfoSection({
    required this.assignmentNumber,
    required this.effectiveAsOfDate,
    required this.entryType,
    required this.source,
    required this.elementProcessingType,
    required this.onEffectiveAsOfDateChanged,
    required this.onEntryTypeChanged,
    required this.onSourceChanged,
    required this.onElementProcessingTypeChanged,
    super.key,
  });

  final String assignmentNumber;
  final DateTime? effectiveAsOfDate;
  final String? entryType;
  final String? source;
  final String? elementProcessingType;
  final ValueChanged<DateTime> onEffectiveAsOfDateChanged;
  final ValueChanged<String?> onEntryTypeChanged;
  final ValueChanged<String?> onSourceChanged;
  final ValueChanged<String?> onElementProcessingTypeChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return AddElementSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddElementSectionTitle(title: loc.payrollAddElementProcessInformation),
          Gap(20.h),
          AddElementFormRow(
            children: [
              DigifyDateField(
                label: loc.payrollAddElementEffectiveAsOfDate,
                isRequired: true,
                hintText: loc.payrollAddElementDateHint,
                initialDate: effectiveAsOfDate,
                onDateSelected: onEffectiveAsOfDateChanged,
              ),
              AddElementLookupSelectField(
                label: loc.payrollAddElementEntryType,
                typeCode: PayLookupTypeCode.entryType,
                isRequired: true,
                value: entryType,
                onChanged: onEntryTypeChanged,
              ),
              DigifyTextField(
                labelText: loc.payrollAddElementAssignmentNumber,
                initialValue: assignmentNumber,
                readOnly: true,
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.grayBg,
              ),
              AddElementLookupSelectField(
                label: loc.payrollAddElementSource,
                typeCode: PayLookupTypeCode.source,
                value: source,
                onChanged: onSourceChanged,
              ),
            ],
          ),
          Gap(16.h),
          AddElementFormRow(
            children: [
              AddElementLookupSelectField(
                label: loc.payrollAddElementElementProcessingType,
                typeCode: PayLookupTypeCode.elementProcessingType,
                value: elementProcessingType,
                onChanged: onElementProcessingTypeChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
