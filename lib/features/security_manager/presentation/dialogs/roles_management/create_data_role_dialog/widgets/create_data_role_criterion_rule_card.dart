import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleCriterionRuleCard extends StatelessWidget {
  const CreateDataRoleCriterionRuleCard({
    super.key,
    required this.index,
    required this.rule,
    required this.showAndDivider,
    required this.onRemove,
    required this.onFieldChanged,
    required this.onOperatorChanged,
    required this.onValueChanged,
  });

  final int index;
  final CreateDataRoleCriterionRule rule;
  final bool showAndDivider;
  final VoidCallback onRemove;
  final ValueChanged<String?> onFieldChanged;
  final ValueChanged<String?> onOperatorChanged;
  final ValueChanged<String?> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: AppColors.sidebarActiveBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: context.textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 16.sp),
                ),
              ),
              Gap(14.w),
              Expanded(
                child: context.isMobile
                    ? Column(
                        children: [
                          DigifySelectFieldWithLabel<String>(
                            label: DataRoleFormConfig.criterionFieldLabel,
                            items: DataRoleFormConfig.criterionFieldOptions,
                            value: rule.field.isEmpty ? null : rule.field,
                            itemLabelBuilder: (item) => item,
                            isRequired: true,
                            onChanged: onFieldChanged,
                          ),
                          Gap(12.h),
                          DigifySelectFieldWithLabel<String>(
                            label: DataRoleFormConfig.criterionOperatorLabel,
                            items: DataRoleFormConfig.criterionOperatorOptions,
                            value: rule.operatorValue.isEmpty ? null : rule.operatorValue,
                            itemLabelBuilder: (item) => item,
                            isRequired: true,
                            onChanged: onOperatorChanged,
                          ),
                          Gap(12.h),
                          DigifyTextField(
                            labelText: DataRoleFormConfig.criterionValueLabel,
                            hintText: DataRoleFormConfig.criterionValueHint,
                            isRequired: true,
                            initialValue: rule.value,
                            validator: (value) => value == null || value.trim().isEmpty ? 'Value is required' : null,
                            onChanged: onValueChanged,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: DigifySelectFieldWithLabel<String>(
                              label: DataRoleFormConfig.criterionFieldLabel,
                              items: DataRoleFormConfig.criterionFieldOptions,
                              value: rule.field.isEmpty ? null : rule.field,
                              itemLabelBuilder: (item) => item,
                              isRequired: true,
                              onChanged: onFieldChanged,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: DigifySelectFieldWithLabel<String>(
                              label: DataRoleFormConfig.criterionOperatorLabel,
                              items: DataRoleFormConfig.criterionOperatorOptions,
                              value: rule.operatorValue.isEmpty ? null : rule.operatorValue,
                              itemLabelBuilder: (item) => item,
                              isRequired: true,
                              onChanged: onOperatorChanged,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: DigifyTextField(
                              labelText: DataRoleFormConfig.criterionValueLabel,
                              hintText: DataRoleFormConfig.criterionValueHint,
                              isRequired: true,
                              initialValue: rule.value,
                              validator: (value) => value == null || value.trim().isEmpty ? 'Value is required' : null,
                              onChanged: onValueChanged,
                            ),
                          ),
                        ],
                      ),
              ),
              Gap(12.w),
              Padding(
                padding: EdgeInsets.only(top: 28.h),
                child: DigifyAssetButton(
                  assetPath: DataRoleFormConfig.deleteIconPath,
                  width: 18,
                  height: 18,
                  color: AppColors.deleteIconRed,
                  onTap: onRemove,
                  padding: 4.w,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
          if (showAndDivider) ...[
            Gap(12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(color: AppColors.sidebarActiveBg, borderRadius: BorderRadius.circular(999.r)),
              child: Text(
                'AND',
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
