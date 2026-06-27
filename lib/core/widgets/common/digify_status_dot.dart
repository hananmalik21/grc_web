import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyStatusDot extends StatelessWidget {
  final Color color;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  const DigifyStatusDot({super.key, required this.color, this.size = 7, this.borderColor, this.borderWidth = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: borderWidth > 0 && borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null,
      ),
    );
  }
}

class DigifyStatusDotContainer extends StatelessWidget {
  final Color dotColor;
  final double dotSize;
  final Color backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const DigifyStatusDotContainer({
    super.key,
    required this.dotColor,
    this.dotSize = 7,
    required this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius = 999,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: DigifyStatusDot(color: dotColor, size: dotSize),
    );
  }
}
