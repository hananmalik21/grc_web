import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AppInfoTooltip extends StatefulWidget {
  final String message;
  final Widget? child;

  const AppInfoTooltip({super.key, required this.message, this.child});

  @override
  State<AppInfoTooltip> createState() => _AppInfoTooltipState();
}

class _AppInfoTooltipState extends State<AppInfoTooltip> {
  final _tooltipController = SuperTooltipController();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        _tooltipController.showTooltip();
      },
      child: SuperTooltip(
        controller: _tooltipController,
        positionConfig: const PositionConfiguration(preferredDirection: TooltipDirection.up),
        style: TooltipStyle(
          backgroundColor: isDark ? AppColors.inputBgDark : AppColors.sidebarBackground,
          hasShadow: true,
          shadowColor: AppColors.shadowColor,
          shadowBlurRadius: 8,
          borderColor: isDark ? AppColors.inputBorderDark : AppColors.transparent,
          borderWidth: isDark ? 1.0 : 0.0,
          borderRadius: 10.r,
        ),
        closeButtonConfig: const CloseButtonConfiguration(show: false),
        content: Material(
          color: AppColors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
            child: Text(
              widget.message,
              style: TextStyle(color: AppColors.onPrimary, fontSize: 12.sp, fontWeight: FontWeight.w500, height: 1.4),
              softWrap: true,
            ),
          ),
        ),
        child: widget.child ?? Icon(Icons.info_outline_rounded, color: AppColors.textTertiary, size: 20.w),
      ),
    );
  }
}
