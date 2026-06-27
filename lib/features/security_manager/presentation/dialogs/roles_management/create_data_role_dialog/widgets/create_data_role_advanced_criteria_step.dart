import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_criterion_rule_card.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleAdvancedCriteriaStep extends StatelessWidget {
  const CreateDataRoleAdvancedCriteriaStep({
    super.key,
    required this.criteriaLogic,
    required this.criteriaRules,
    required this.onCriteriaLogicChanged,
    required this.onAddCriterion,
    required this.onRemoveCriterion,
    required this.onRuleFieldChanged,
  });

  final String criteriaLogic;
  final List<CreateDataRoleCriterionRule> criteriaRules;
  final ValueChanged<String> onCriteriaLogicChanged;
  final VoidCallback onAddCriterion;
  final ValueChanged<int> onRemoveCriterion;
  final void Function(int, CreateDataRoleCriterionField, String?) onRuleFieldChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleStepHeader(title: DataRoleFormConfig.stepLabels[3]),
        Gap(18.h),
        Text(
          DataRoleFormConfig.criteriaLogicTitle,
          style: context.textTheme.labelLarge?.copyWith(color: AppColors.grayBgDark, fontSize: 14.sp),
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: CreateDataRoleLogicButton(
                label: DataRoleFormConfig.criteriaLogicAndLabel,
                isSelected: criteriaLogic == 'AND',
                onTap: () => onCriteriaLogicChanged('AND'),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: CreateDataRoleLogicButton(
                label: DataRoleFormConfig.criteriaLogicOrLabel,
                isSelected: criteriaLogic == 'OR',
                onTap: () => onCriteriaLogicChanged('OR'),
              ),
            ),
          ],
        ),
        Gap(20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DataRoleFormConfig.criteriaRulesTitle} (${criteriaRules.length})',
              style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            AppButton.primary(
              label: DataRoleFormConfig.addCriterionLabel,
              onPressed: onAddCriterion,
              svgPath: DataRoleFormConfig.addIconPath,
            ),
          ],
        ),
        Gap(14.h),
        Column(
          children: [
            for (int index = 0; index < criteriaRules.length; index++) ...[
              CreateDataRoleCriterionRuleCard(
                index: index,
                rule: criteriaRules[index],
                showAndDivider: criteriaLogic == 'AND' && index != criteriaRules.length - 1,
                onRemove: () => onRemoveCriterion(index),
                onFieldChanged: (value) => onRuleFieldChanged(index, CreateDataRoleCriterionField.field, value),
                onOperatorChanged: (value) => onRuleFieldChanged(index, CreateDataRoleCriterionField.operator, value),
                onValueChanged: (value) => onRuleFieldChanged(index, CreateDataRoleCriterionField.value, value),
              ),
              if (index != criteriaRules.length - 1) Gap(10.h),
            ],
          ],
        ),
      ],
    );
  }
}
