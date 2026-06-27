import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EntitlementAccrualSection extends StatelessWidget {
  final bool isDark;
  final EntitlementAccrual entitlement;

  const EntitlementAccrualSection({super.key, required this.isDark, required this.entitlement});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Entitlement & Accrual',
      iconPath: Assets.icons.leaveManagementIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: TextEditingController(text: entitlement.annualEntitlement),
                      labelText: 'Annual Entitlement (days)',
                      hintText: 'Enter annual entitlement',
                      filled: true,
                      fillColor: AppColors.cardBackground,
                    ),
                    Text(
                      'Total days per year',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Accrual Method',
                  items: ['Monthly', 'Quarterly', 'Yearly'],
                  itemLabelBuilder: (item) => item,
                  value: entitlement.accrualMethod,
                  onChanged: null,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: TextEditingController(text: entitlement.accrualRate),
                  labelText: 'Accrual Rate (days per period)',
                  hintText: 'Enter accrual rate',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: TextEditingController(text: entitlement.effectiveDate),
                  labelText: 'Effective Date',
                  hintText: 'Select effective date',
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.roleBadgeBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.permissionBadgeBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyCheckbox(value: entitlement.enableProRataCalculation, onChanged: null),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.h,
                    children: [
                      Text(
                        'Enable Pro-Rata Calculation',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.infoTextDark : AppColors.statIconBlue,
                        ),
                      ),
                      Text(
                        'Calculate leave entitlement proportionally for partial years (new joiners, resignations)',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.sp,
                          color: isDark ? AppColors.infoTextDark.withValues(alpha: 0.8) : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
