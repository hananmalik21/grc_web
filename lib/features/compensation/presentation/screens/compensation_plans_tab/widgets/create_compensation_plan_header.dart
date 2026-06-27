import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateCompensationPlanHeader extends StatelessWidget {
  final bool canGoBack;
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback? onBack;
  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final String? title;
  final String? description;
  final String? submitLabel;

  const CreateCompensationPlanHeader({
    super.key,
    required this.canGoBack,
    required this.isLastStep,
    required this.isSubmitting,
    required this.onBack,
    required this.onCancel,
    required this.onContinue,
    this.title,
    this.description,
    this.submitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: title ?? 'Create New Plan',
      description: description ?? 'Complete the 6-step process to set up your compensation plan.',
      trailing: Row(
        children: [
          AppButton.outline(label: 'Back', onPressed: canGoBack ? onBack : null),
          Gap(12.w),
          AppButton.outline(label: 'Cancel', onPressed: onCancel),
          Gap(12.w),
          AppButton.primary(
            label: isLastStep ? (submitLabel ?? 'Create Plan') : 'Continue',
            isLoading: isSubmitting,
            svgPath: isLastStep ? Assets.icons.checkIconGreen.path : null,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
