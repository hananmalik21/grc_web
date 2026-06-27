import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifySliderFieldWithLabel extends StatelessWidget {
  const DigifySliderFieldWithLabel({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.isRequired = false,
    this.activeColor,
    this.inactiveColor,
    this.showMinMaxLabels = true,
    this.showValueBadge = false,
    this.valueDisplay = DigifySliderValueDisplay.center,
    this.valueFormatter,
    this.minLabel,
    this.maxLabel,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool isRequired;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showMinMaxLabels;
  final bool showValueBadge;
  final DigifySliderValueDisplay valueDisplay;
  final String Function(double value)? valueFormatter;
  final String? minLabel;
  final String? maxLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final active = activeColor ?? AppColors.primary;
    final formatValue = valueFormatter ?? (v) => '${v.round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? context.themeTextPrimary : AppColors.textDarkSlate,
                      ),
                    ),
                    if (isRequired)
                      TextSpan(
                        text: ' *',
                        style: context.textTheme.titleSmall?.copyWith(color: AppColors.error),
                      ),
                  ],
                ),
              ),
            ),
            if (showValueBadge) ...[
              Gap(12.w),
              DigifyCapsule(
                label: formatValue(value),
                textColor: active,
                backgroundColor: active.withValues(alpha: 0.1),
              ),
            ],
          ],
        ),
        Gap(10.h),
        DigifySlider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          showMinMaxLabels: showMinMaxLabels,
          valueDisplay: showValueBadge ? DigifySliderValueDisplay.none : valueDisplay,
          valueFormatter: valueFormatter,
          minLabel: minLabel,
          maxLabel: maxLabel,
        ),
      ],
    );
  }
}
