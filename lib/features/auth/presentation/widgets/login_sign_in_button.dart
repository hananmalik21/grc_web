import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginSignInButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? suffixIcon;
  final double? height;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const LoginSignInButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.suffixIcon,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  State<LoginSignInButton> createState() => _LoginSignInButtonState();
}

class _LoginSignInButtonState extends State<LoginSignInButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    // Adjusted scale to 0.98 for a subtler, more stable press feel
    _scaleAnimation = _controller.drive(Tween<double>(begin: 1.0, end: 0.98));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isLoading || widget.onPressed == null;
    final bgColor = widget.backgroundColor ?? AppColors.authButton;
    final effectiveHeight =
        widget.height ??
        context.responsiveFine<double>(mobile: 50, tabletSmall: 52, tabletMedium: 54, tabletLarge: 56, desktop: 58);
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(14.r);
    final labelFontSize =
        widget.fontSize ??
        context.responsiveFine<double>(mobile: 14, tabletSmall: 14.5, tabletMedium: 15, tabletLarge: 15.5, desktop: 16);
    final iconGap = context.responsiveFine<double>(
      mobile: 8,
      tabletSmall: 10,
      tabletMedium: 12,
      tabletLarge: 12,
      desktop: 12,
    );
    final iconShift = context.responsiveFine<double>(
      mobile: 2,
      tabletSmall: 3,
      tabletMedium: 4,
      tabletLarge: 4,
      desktop: 4,
    );
    final loadingSize = context.responsiveFine<double>(
      mobile: 20,
      tabletSmall: 21,
      tabletMedium: 22,
      tabletLarge: 23,
      desktop: 24,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: effectiveHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? bgColor.withValues(alpha: 0.6)
                      : _isHovered
                      ? bgColor.withValues(alpha: 0.85)
                      : bgColor,
                  borderRadius: effectiveBorderRadius,
                  boxShadow: _isHovered && !isDisabled
                      ? [BoxShadow(color: bgColor.withValues(alpha: 0.25), blurRadius: 15, offset: const Offset(0, 5))]
                      : [],
                ),
                child: _buildContent(
                  context,
                  iconGap: iconGap,
                  iconShift: iconShift,
                  loadingSize: loadingSize,
                  labelFontSize: labelFontSize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required double iconGap,
    required double iconShift,
    required double loadingSize,
    required double labelFontSize,
  }) {
    if (widget.isLoading) {
      return AppLoadingIndicator(type: LoadingType.circle, color: Colors.white, size: loadingSize.sp);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: labelFontSize.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          Gap(iconGap),
          // Using Transform.translate inside TweenAnimationBuilder to keep layout stable
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween<double>(begin: 0, end: _isHovered ? iconShift.w : 0),
            builder: (context, offset, child) {
              return Transform.translate(offset: Offset(offset, 0), child: child);
            },
            child: widget.suffixIcon,
          ),
        ],
      ],
    );
  }
}
