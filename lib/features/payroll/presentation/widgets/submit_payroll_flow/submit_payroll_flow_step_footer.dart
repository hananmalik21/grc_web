import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubmitPayrollFlowStepFooter extends StatelessWidget {
  const SubmitPayrollFlowStepFooter({
    this.primaryLabel,
    this.onPrimaryPressed,
    this.showBack = false,
    this.backLabel,
    this.onBackPressed,
    super.key,
  }) : assert(
         (primaryLabel == null) == (onPrimaryPressed == null),
         'primaryLabel and onPrimaryPressed must both be set or both be null',
       );

  final String? primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool showBack;
  final String? backLabel;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DigifyDivider.horizontal(),
        Gap(25.h),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.end,
            children: [
              if (showBack && backLabel != null && onBackPressed != null)
                AppButton.outline(label: backLabel!, onPressed: onBackPressed),
              if (primaryLabel != null && onPrimaryPressed != null)
                AppButton.primary(label: primaryLabel!, onPressed: onPrimaryPressed),
            ],
          ),
        ),
      ],
    );
  }
}
