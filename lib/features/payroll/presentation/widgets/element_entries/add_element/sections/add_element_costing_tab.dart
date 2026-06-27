import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_lookup_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddElementCostingTab extends StatelessWidget {
  const AddElementCostingTab({
    required this.costAllocationKeyFlexfield,
    required this.costingType,
    required this.accountCode,
    required this.costCentre,
    required this.showEmptyMessage,
    required this.onCostAllocationKeyFlexfieldChanged,
    required this.onCostingTypeChanged,
    required this.onAccountCodeChanged,
    required this.onCostCentreChanged,
    super.key,
  });

  final String? costAllocationKeyFlexfield;
  final String? costingType;
  final String accountCode;
  final String costCentre;
  final bool showEmptyMessage;
  final ValueChanged<String?> onCostAllocationKeyFlexfieldChanged;
  final ValueChanged<String?> onCostingTypeChanged;
  final ValueChanged<String> onAccountCodeChanged;
  final ValueChanged<String> onCostCentreChanged;

  static const int _rowColumns = 4;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.payrollAddElementCostingDescription,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(20.h),
        AddElementFormRow(
          columns: _rowColumns,
          children: [
            AddElementLookupSelectField(
              label: loc.payrollAddElementCostAllocationKeyFlexfield,
              typeCode: PayLookupTypeCode.costAllocationKeyField,
              value: costAllocationKeyFlexfield,
              onChanged: onCostAllocationKeyFlexfieldChanged,
            ),
            AddElementLookupSelectField(
              label: loc.payrollAddElementCostingType,
              typeCode: PayLookupTypeCode.costingType,
              value: costingType,
              onChanged: onCostingTypeChanged,
            ),
            DigifyTextField(
              initialValue: accountCode,
              labelText: loc.payrollAddElementAccountCode,
              hintText: loc.payrollAddElementAccountCodeHint,
              filled: true,
              onChanged: onAccountCodeChanged,
            ),
            DigifyTextField(
              initialValue: costCentre,
              labelText: loc.payrollAddElementCostCentre,
              hintText: loc.payrollAddElementCostCentreHint,
              filled: true,
              onChanged: onCostCentreChanged,
            ),
          ],
        ),
        if (showEmptyMessage) ...[
          Gap(20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.grayBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              loc.payrollAddElementCostingEmptyMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
