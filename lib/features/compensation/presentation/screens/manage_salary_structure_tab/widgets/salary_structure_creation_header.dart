import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryStructureCreationHeader extends StatelessWidget {
  final bool canGoBack;
  final bool isLastStep;
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const SalaryStructureCreationHeader({
    super.key,
    required this.canGoBack,
    required this.isLastStep,
    required this.isLoading,
    required this.onBack,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: 'Create New Salary Structure',
      description: 'Complete the 5-step process to define your compensation structure',
      trailing: Row(
        children: [
          AppButton.outline(label: 'Back', onPressed: canGoBack ? onBack : null),
          Gap(12.w),
          AppButton.outline(label: 'Cancel', onPressed: onCancel),
          Gap(12.w),
          AppButton.primary(
            label: isLastStep ? 'Save Structure' : 'Continue',
            svgPath: isLastStep ? Assets.icons.checkIconGreen.path : null,
            isLoading: isLoading,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
