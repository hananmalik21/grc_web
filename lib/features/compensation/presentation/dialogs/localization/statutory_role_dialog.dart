import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';

class StatutoryRoleDialog extends ConsumerStatefulWidget {
  const StatutoryRoleDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const StatutoryRoleDialog(),
    );
  }

  @override
  ConsumerState<StatutoryRoleDialog> createState() =>
      _StatutoryRoleDialogState();
}

class _StatutoryRoleDialogState extends ConsumerState<StatutoryRoleDialog> {
  final _ruleNameController = TextEditingController();
  final _employerRateController = TextEditingController();
  final _employeeRateController = TextEditingController();
  final _ceilingAmountController = TextEditingController();
  final _applicableCategoriesController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _ruleNameController.dispose();
    _employerRateController.dispose();
    _employeeRateController.dispose();
    _ceilingAmountController.dispose();
    _applicableCategoriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Add Statutory Rule',
      subtitle:
          'Configure a new statutory benefit or regulation for the selected country',
      width: 500.w,
      content: Column(
        children: [
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _ruleNameController,
              labelText: 'Rule Name',
              isRequired: true,
              hintText: 'e.g. Social Insurance, GOSI',
            ),
            Gap(16.h),
            DigifySelectFieldWithLabel(
              label: 'Country',
              isRequired: true,
              items: [],
              itemLabelBuilder: (item) => item,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _ruleNameController,
                    labelText: 'Rule Name',
                    isRequired: true,
                    hintText: 'e.g. Social Insurance, GOSI',
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifySelectFieldWithLabel(
                    label: 'Country',
                    isRequired: true,
                    items: [],
                    itemLabelBuilder: (item) => item,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          DigifySelectFieldWithLabel(
            label: 'Contribution Basis',

            items: [],
            itemLabelBuilder: (item) => item,
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _employerRateController,
              labelText: 'Employer Rate',
              hintText: 'e.g. 11.5%',
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _employeeRateController,
              labelText: 'Employee Rate',
              hintText: 'e.g. 10.5%',
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _employerRateController,
                    labelText: 'Employer Rate',
                    hintText: 'e.g. 11.5%',
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _employeeRateController,
                    labelText: 'Employee Rate',
                    hintText: 'e.g. 10.5%',
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          DigifyTextField(
            controller: _ceilingAmountController,
            labelText: 'Ceiling Amount',
            hintText: 'e.g. 2,750 KWD or No Ceiling',
          ),
          Gap(16.h),
          DigifyTextField(
            controller: _applicableCategoriesController,
            labelText: 'Applicable Categories',
            hintText: 'e.g. Nationals Only, GCC, All Employees',
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _notesController,
            labelText: 'Notes / Description',
            hintText: 'Additional Information or complaince notes',
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        Gap(16.w),
        AppButton.primary(
          label: 'Add Rule',
          icon: Icons.add,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
