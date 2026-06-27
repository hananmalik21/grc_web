import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateJobPostingYnFlagRow extends StatelessWidget {
  const CreateJobPostingYnFlagRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.yesLabel,
    required this.noLabel,
    this.enabled = true,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String yesLabel;
  final String noLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(8.h),
        Row(
          children: [
            DigifyRadio<String>(
              value: 'Y',
              groupValue: value,
              label: yesLabel,
              enabled: enabled,
              onChanged: enabled ? (val) => onChanged(val ?? 'N') : null,
            ),
            Gap(24.w),
            DigifyRadio<String>(
              value: 'N',
              groupValue: value,
              label: noLabel,
              enabled: enabled,
              onChanged: enabled ? (val) => onChanged(val ?? 'N') : null,
            ),
          ],
        ),
      ],
    );
  }
}
