import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/create_new_component_provider.dart';
import 'component_creation_shared.dart';

class PayrollAccountingStep extends ConsumerWidget {
  final TextEditingController payrollCodeController;
  final TextEditingController glAccountController;
  final TextEditingController costCenterController;
  final TextEditingController displayOrderController;

  const PayrollAccountingStep({
    super.key,
    required this.payrollCodeController,
    required this.glAccountController,
    required this.costCenterController,
    required this.displayOrderController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(createNewComponentProvider.notifier);
    return ComponentCreationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: DigifyAsset(
              assetPath: Assets.icons.budgetIcon.path,
              width: 17.sp,
              height: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Payroll Integration',
            subtitle: 'Map this component to payroll systems and accounting codes',
          ),
          Gap(24.h),
          Column(
            children: [
              ComponentCreationResponsiveRow(
                left: DigifyTextField.normal(
                  controller: payrollCodeController,
                  labelText: 'Payroll Code',
                  isRequired: true,
                  hintText: 'e.g., PAY-HOU-001',
                  inputFormatters: FieldFormat.codeOrSlug,
                  onChanged: notifier.setPayrollCode,
                ),
                right: DigifyTextField.normal(
                  controller: glAccountController,
                  labelText: 'GL Account',
                  isRequired: true,
                  hintText: 'e.g., 5210-001',
                  inputFormatters: FieldFormat.codeOrSlug,
                  onChanged: notifier.setGlAccount,
                ),
              ),
              Gap(20.h),
              ComponentCreationResponsiveRow(
                left: DigifyTextField.normal(
                  controller: costCenterController,
                  labelText: 'Cost Center',
                  isRequired: true,
                  hintText: 'e.g., CC-HR-001',
                  inputFormatters: FieldFormat.codeOrSlug,
                  onChanged: notifier.setCostCenter,
                ),
                right: DigifyTextField(
                  controller: displayOrderController,
                  labelText: 'Display Order',
                  isRequired: true,
                  hintText: 'e.g., 2',
                  keyboardType: FieldFormat.integer,
                  inputFormatters: FieldFormat.integerOnly,
                  onChanged: notifier.setDisplayOrder,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
