import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSocialButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback? onTap;

  const LoginSocialButton({super.key, required this.iconPath, this.onTap});

  @override
  State<LoginSocialButton> createState() => _LoginSocialButtonState();
}

class _LoginSocialButtonState extends State<LoginSocialButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48.h,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.authSocialBtnBg.withValues(alpha: 0.8) : AppColors.authSocialBtnBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: _isHovered
                    ? AppColors.authSocialBtnBorder
                    : AppColors.authSocialBtnBorder.withValues(alpha: 0.6),
                width: _isHovered ? 1.2 : 1.0,
              ),
              boxShadow: _isHovered ? AppShadows.primaryShadow : [],
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: widget.iconPath),
          ),
        ),
      ),
    );
  }
}
