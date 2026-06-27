import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool adaptive;
  final double scale;
  final Color? activeTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveTrackColor;
  final Color? inactiveThumbColor;
  final Color? trackOutlineColor;
  final double? width;
  final double? height;
  final double? disabledOpacity;

  const DigifySwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.adaptive = false,
    this.scale = 1,
    this.activeTrackColor,
    this.activeThumbColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
    this.trackOutlineColor,
    this.width,
    this.height,
    this.disabledOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final enabled = onChanged != null;
    final activeTrack = activeTrackColor ?? AppColors.success;
    final activeThumb = activeThumbColor ?? AppColors.buttonTextLight;
    final inactiveTrack = inactiveTrackColor ?? (isDark ? AppColors.cardBorderDark : AppColors.inputBorder);
    final inactiveThumb = inactiveThumbColor ?? AppColors.buttonTextLight;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmall = screenWidth < 480;
    final w = width ?? (isSmall ? 36.0 : 44.w);
    final h = height ?? (isSmall ? 20.0 : 24.h);

    final switchWidget = adaptive
        ? Switch.adaptive(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: activeTrack,
            activeThumbColor: activeThumb,
            inactiveThumbColor: inactiveThumb,
            inactiveTrackColor: inactiveTrack,
            trackOutlineColor: WidgetStateProperty.all(trackOutlineColor),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        : Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: activeTrack,
            activeThumbColor: activeThumb,
            inactiveThumbColor: inactiveThumb,
            inactiveTrackColor: inactiveTrack,
            trackOutlineColor: WidgetStateProperty.all(trackOutlineColor),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );

    final effectiveScale = scale == 1 ? (isSmall ? 0.8 : 1.0) : scale;

    final scaled = effectiveScale == 1.0
        ? switchWidget
        : Transform.scale(scale: effectiveScale, alignment: Alignment.center, child: switchWidget);

    Widget result = SizedBox(
      width: w,
      height: h,
      child: Center(child: scaled),
    );

    if (!enabled) {
      result = Opacity(opacity: disabledOpacity ?? 0.5, child: result);
    }

    return result;
  }
}
