import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum DigifySliderValueDisplay { none, center }

class DigifySlider extends StatelessWidget {
  const DigifySlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.showMinMaxLabels = true,
    this.valueDisplay = DigifySliderValueDisplay.center,
    this.valueFormatter,
    this.minLabel,
    this.maxLabel,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final bool showMinMaxLabels;
  final DigifySliderValueDisplay valueDisplay;
  final String Function(double value)? valueFormatter;
  final String? minLabel;
  final String? maxLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isSmall = context.isMobile;
    final active = activeColor ?? AppColors.primary;
    final inactive = inactiveColor ?? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey);
    final thumb = thumbColor ?? Colors.white;
    final trackHeight = isSmall ? 6.h : 8.h;
    final thumbRadius = isSmall ? 10.r : 12.r;
    final formatValue = valueFormatter ?? (v) => '${v.round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SliderTrack(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: active,
          inactiveColor: inactive,
          thumbColor: thumb,
          trackHeight: trackHeight,
          thumbRadius: thumbRadius,
        ),
        if (showMinMaxLabels || valueDisplay == DigifySliderValueDisplay.center) ...[
          Gap(6.h),
          _SliderLabelsRow(
            minLabel: minLabel ?? formatValue(min),
            maxLabel: maxLabel ?? formatValue(max),
            centerLabel: valueDisplay == DigifySliderValueDisplay.center ? formatValue(value) : null,
            centerColor: active,
            showMinMax: showMinMaxLabels,
          ),
        ],
      ],
    );
  }
}

class _SliderTrack extends StatelessWidget {
  const _SliderTrack({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    required this.trackHeight,
    required this.thumbRadius,
    this.divisions,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double trackHeight;
  final double thumbRadius;

  @override
  Widget build(BuildContext context) {
    final trackRadius = trackHeight / 2;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: inactiveColor.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(trackRadius + 10.h),
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: activeColor,
          inactiveTrackColor: Colors.transparent,
          thumbColor: thumbColor,
          overlayColor: activeColor.withValues(alpha: 0.12),
          trackHeight: trackHeight,
          trackShape: RoundedRectSliderTrackShape(),
          thumbShape: _DigifySliderThumbShape(enabledThumbRadius: thumbRadius, borderColor: activeColor),
          overlayShape: RoundSliderOverlayShape(overlayRadius: thumbRadius + 6.r),
          tickMarkShape: divisions != null
              ? RoundSliderTickMarkShape(tickMarkRadius: 2.r)
              : SliderTickMarkShape.noTickMark,
          activeTickMarkColor: activeColor.withValues(alpha: 0.5),
          inactiveTickMarkColor: context.themeTextMuted.withValues(alpha: 0.4),
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: activeColor,
          showValueIndicator: ShowValueIndicator.onlyForDiscrete,
        ),
        child: Slider(value: value.clamp(min, max), min: min, max: max, divisions: divisions, onChanged: onChanged),
      ),
    );
  }
}

class _SliderLabelsRow extends StatelessWidget {
  const _SliderLabelsRow({
    required this.minLabel,
    required this.maxLabel,
    required this.showMinMax,
    this.centerLabel,
    this.centerColor,
  });

  final String minLabel;
  final String maxLabel;
  final String? centerLabel;
  final Color? centerColor;
  final bool showMinMax;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = context.textTheme.bodySmall?.copyWith(
      color: context.themeTextSecondary,
      fontWeight: FontWeight.w500,
    );
    final centerStyle = context.textTheme.titleLarge?.copyWith(
      color: centerColor ?? AppColors.primary,
      fontWeight: FontWeight.w700,
    );

    if (centerLabel == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(minLabel, style: mutedStyle),
          Text(maxLabel, style: mutedStyle),
        ],
      );
    }

    return Row(
      children: [
        if (showMinMax)
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(minLabel, style: mutedStyle),
            ),
          )
        else
          const Spacer(),
        Text(centerLabel!, style: centerStyle),
        if (showMinMax)
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(maxLabel, style: mutedStyle),
            ),
          )
        else
          const Spacer(),
      ],
    );
  }
}

class _DigifySliderThumbShape extends SliderComponentShape {
  const _DigifySliderThumbShape({required this.enabledThumbRadius, required this.borderColor});

  final double enabledThumbRadius;
  final Color borderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius + 3);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final radius = enabledThumbRadius;
    final scale = 1 + (activationAnimation.value * 0.08);
    final scaledRadius = radius * scale;

    final shadowPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(0, 2), scaledRadius, shadowPaint);

    final fillPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.white;
    canvas.drawCircle(center, scaledRadius, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, scaledRadius - 1.25, borderPaint);
  }
}
