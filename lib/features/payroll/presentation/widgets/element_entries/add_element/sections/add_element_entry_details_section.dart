import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_component_selection_field.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_lookup_select_field.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddElementEntryDetailsSection extends StatelessWidget {
  const AddElementEntryDetailsSection({
    required this.employeeGuid,
    required this.elementComponent,
    required this.elementClassification,
    required this.subpriority,
    required this.onElementComponentChanged,
    required this.onElementClassificationChanged,
    required this.onSubpriorityChanged,
    super.key,
  });

  final String? employeeGuid;
  final EmployeeAssignedComponent? elementComponent;
  final String? elementClassification;
  final String subpriority;
  final ValueChanged<EmployeeAssignedComponent?> onElementComponentChanged;
  final ValueChanged<String?> onElementClassificationChanged;
  final ValueChanged<String> onSubpriorityChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return AddElementSectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(28.w, 20.h, 28.w, 20.h),
            child: RichText(
              text: TextSpan(
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                children: [
                  TextSpan(text: loc.payrollAddElementEntryDetails),
                  TextSpan(
                    text: '  ${loc.payrollAddElementElementConfiguration}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(29.w, 24.h, 29.w, 29.h),
            child: AddElementFormRow(
              children: [
                AddElementComponentSelectionField(
                  label: loc.payrollAddElementElement,
                  isRequired: true,
                  employeeGuid: employeeGuid,
                  selectedComponent: elementComponent,
                  onChanged: onElementComponentChanged,
                ),
                AddElementLookupSelectField(
                  label: loc.payrollAddElementElementClassificationName,
                  typeCode: PayLookupTypeCode.elementClassificationCode,
                  value: elementClassification,
                  onChanged: onElementClassificationChanged,
                ),
                DigifyTextField(
                  initialValue: subpriority,
                  labelText: loc.payrollAddElementSubpriority,
                  hintText: loc.payrollAddElementSubpriorityHint,
                  filled: true,
                  onChanged: onSubpriorityChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
