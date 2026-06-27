import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/dashboard/presentation/module_selection/module_selection_sizing.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubModuleSizeSpec {
  final double iconBox;
  final double iconSize;
  final double badgeBox;
  final double badgeFont;

  final double topPadding;
  final double gapAfterIcon;
  final double gapBeforeSubtitle;

  final double titleFont;
  final double subtitleFont;

  final double titleHPad;
  final double subtitleHPad;
  final DialogBreakpoint breakpoint;

  const SubModuleSizeSpec({
    required this.iconBox,
    required this.iconSize,
    required this.badgeBox,
    required this.badgeFont,
    required this.topPadding,
    required this.gapAfterIcon,
    required this.gapBeforeSubtitle,
    required this.titleFont,
    required this.subtitleFont,
    required this.titleHPad,
    required this.subtitleHPad,
    required this.breakpoint,
  });
}

class SubModuleButton extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;
  final SubModuleSizeSpec spec;

  const SubModuleButton({super.key, required this.button, required this.onTap, required this.spec});

  @override
  State<SubModuleButton> createState() => _SubModuleButtonState();
}

class _SubModuleButtonState extends State<SubModuleButton> {
  bool _isHovered = false;

  void _clearHover() {
    if (_isHovered) setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _clearHover(),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.05),
                  offset: Offset(0, _isHovered ? 8 : 2),
                  blurRadius: _isHovered ? 24 : 8,
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.r),
                    color: context.isDark
                        ? AppColors.cardBackgroundDark.withValues(alpha: _isHovered ? 0.85 : 0.7)
                        : AppColors.cardBackground.withValues(alpha: _isHovered ? 0.75 : 0.6),
                    border: Border.all(
                      color: context.isDark
                          ? AppColors.cardBorderDark.withValues(alpha: _isHovered ? 0.8 : 0.5)
                          : AppColors.cardBorder.withValues(alpha: _isHovered ? 0.8 : 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: spec.iconBox,
                          height: spec.iconBox,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            color: AppColors.primary,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.cardBackground.withValues(alpha: 0.2),
                                      AppColors.cardBackground.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutBack,
                                  turns: _isHovered ? 0.02 : 0.0,
                                  child: DigifyAsset(
                                    assetPath: widget.button.icon,
                                    width: spec.iconSize,
                                    height: spec.iconSize,
                                    color: AppColors.cardBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Gap(spec.gapAfterIcon.h),

                        // Title
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: spec.titleHPad),
                          child: Text(
                            widget.button.label,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontSize: spec.titleFont.sp,
                              color: AppColors.dialogTitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
