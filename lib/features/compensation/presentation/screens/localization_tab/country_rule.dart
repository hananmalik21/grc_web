import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../../gen/assets.gen.dart';
import '../../widgets/localization/country_rule/country_identification_form.dart';
import '../../widgets/localization/country_rule/country_rule_stepper.dart';
import '../../widgets/localization/country_rule/review_publish_form.dart';
import '../../widgets/localization/country_rule/salary_structure_form.dart';
import '../../widgets/localization/country_rule/statutory_compliance_form.dart';

class CountryRuleScreen extends ConsumerStatefulWidget {
  const CountryRuleScreen({super.key});

  @override
  ConsumerState<CountryRuleScreen> createState() => _CountryRuleScreenState();
}

class _CountryRuleScreenState extends ConsumerState<CountryRuleScreen> {
  CountryRuleStep _currentStep = CountryRuleStep.basicInformation;

  void _nextStep() {
    if (_currentStep == CountryRuleStep.basicInformation) {
      setState(() => _currentStep = CountryRuleStep.salaryStructure);
    } else if (_currentStep == CountryRuleStep.salaryStructure) {
      setState(() => _currentStep = CountryRuleStep.statutoryCompliance);
    } else if (_currentStep == CountryRuleStep.statutoryCompliance) {
      setState(() => _currentStep = CountryRuleStep.reviewPublish);
    }
  }

  void _previousStep() {
    if (_currentStep == CountryRuleStep.reviewPublish) {
      setState(() => _currentStep = CountryRuleStep.statutoryCompliance);
    } else if (_currentStep == CountryRuleStep.statutoryCompliance) {
      setState(() => _currentStep = CountryRuleStep.salaryStructure);
    } else if (_currentStep == CountryRuleStep.salaryStructure) {
      setState(() => _currentStep = CountryRuleStep.basicInformation);
    } else if (_currentStep == CountryRuleStep.basicInformation) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigifyTabHeader(
            title: "Create Country Rule",
            trailing: Row(
              children: [
                AppButton.outline(label: 'Back', icon: Icons.arrow_back, onPressed: _previousStep),
                Gap(12.w),
                AppButton.outline(label: 'Save Draft', svgPath: Assets.icons.saveConfigIcon.path, onPressed: () {}),
                Gap(12.w),
                AppButton.primary(label: 'Create & Publish', icon: Icons.send, onPressed: () {}),
              ],
            ),
          ),
          Gap(24.h),
          CountryRuleStepper(currentStep: _currentStep),
          Gap(24.h),
          if (_currentStep == CountryRuleStep.basicInformation)
            const CountryIdentificationForm()
          else if (_currentStep == CountryRuleStep.salaryStructure)
            const SalaryStructureForm()
          else if (_currentStep == CountryRuleStep.statutoryCompliance)
            const StatutoryComplianceForm()
          else if (_currentStep == CountryRuleStep.reviewPublish)
            const ReviewPublishForm()
          else
            const SizedBox.shrink(),
          Gap(24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep == CountryRuleStep.salaryStructure ||
                  _currentStep == CountryRuleStep.statutoryCompliance ||
                  _currentStep == CountryRuleStep.reviewPublish)
                AppButton.outline(
                  label: _currentStep == CountryRuleStep.salaryStructure
                      ? 'Back to Basic Information'
                      : _currentStep == CountryRuleStep.statutoryCompliance
                      ? 'Back to Salary Structure'
                      : 'Back to Statutory & Compliance',
                  onPressed: _previousStep,
                )
              else
                const SizedBox.shrink(),

              if (_currentStep == CountryRuleStep.basicInformation)
                AppButton.primary(label: 'Continue to Salary Structure', onPressed: _nextStep)
              else if (_currentStep == CountryRuleStep.salaryStructure)
                AppButton.primary(label: 'Continue to Statutory & Compliance', onPressed: _nextStep)
              else if (_currentStep == CountryRuleStep.statutoryCompliance)
                AppButton.primary(label: 'Continue to Review', onPressed: _nextStep)
              else if (_currentStep == CountryRuleStep.reviewPublish)
                Row(
                  children: [
                    AppButton.outline(
                      label: 'Save as Draft',
                      svgPath: Assets.icons.saveConfigIcon.path,
                      onPressed: () {},
                    ),
                    Gap(12.w),
                    AppButton.primary(label: 'Create & Publish', icon: Icons.send_outlined, onPressed: () {}),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
