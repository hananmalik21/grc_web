import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dashboard_button_model.dart';

class DashboardModuleButton extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;
  final bool isDragging;

  const DashboardModuleButton({super.key, required this.button, required this.onTap, required this.isDragging});

  @override
  State<DashboardModuleButton> createState() => _DashboardModuleButtonState();
}

class _DashboardModuleButtonState extends State<DashboardModuleButton> {
  bool _isHovered = false;

  void _clearHover() {
    if (_isHovered) setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.button;
    final bool canShowHover = _isHovered && !widget.isDragging;

    final double iconBoxSize = context.responsiveFine(
      mobile: 44.0,
      tabletSmall: 48.0,
      tabletMedium: 52.0,
      tabletLarge: 54.0,
      desktop: 56.0,
    );
    final double iconSize = context.responsiveFine(
      mobile: 22.0,
      tabletSmall: 24.0,
      tabletMedium: 26.0,
      tabletLarge: 27.0,
      desktop: 28.0,
    );
    final double fontSize = context.responsive(mobile: 10.0.sp, tablet: 10.5.sp, desktop: 11.0.sp);
    final double labelHeight = context.responsive(mobile: 32.0.h, tablet: 34.0.h, desktop: 36.0.h);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.isDragging) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!widget.isDragging) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) => _clearHover(),
        onPanDown: (_) => _clearHover(),
        onLongPressStart: (_) => _clearHover(),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: canShowHover ? 1.05 : 1.0,
          curve: Curves.easeOutBack,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            offset: canShowHover ? const Offset(0, -0.02) : Offset.zero,
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: canShowHover ? context.themeCardBackground : null,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: _buildContent(
                  context,
                  button,
                  canShowHover,
                  iconBoxSize: iconBoxSize,
                  iconSize: iconSize,
                  fontSize: fontSize,
                  labelHeight: labelHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardButton button,
    bool canShowHover, {
    required double iconBoxSize,
    required double iconSize,
    required double fontSize,
    required double labelHeight,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: button.color,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: button.color.withValues(alpha: canShowHover ? 0.4 : 0.3),
                    blurRadius: canShowHover ? 15 : 10,
                    offset: Offset(0, canShowHover ? 6 : 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white.withValues(alpha: 0.25), Colors.white.withValues(alpha: 0.0)],
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      turns: canShowHover ? 0.02 : 0.0,
                      child: DigifyAsset(
                        assetPath: button.icon,
                        width: iconSize,
                        height: iconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (button.badgeCount != null && button.badgeCount! > 0)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(color: AppColors.brandRed, shape: BoxShape.circle),
                  constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                  child: Center(
                    child: Text(
                      '${button.badgeCount}',
                      style: TextStyle(color: Colors.white, fontSize: 8.5.sp, fontWeight: FontWeight.bold, height: 1),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Gap(6.h),
        SizedBox(
          height: labelHeight,
          child: Text(
            button.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.labelLarge.copyWith(
              fontSize: fontSize,
              color: canShowHover ? AppColors.primary : context.themeTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
