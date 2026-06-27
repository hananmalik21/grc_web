import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionStatusChip extends StatelessWidget {
  final ActiveSessionStatus status;

  const ActiveSessionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final (bg, border, text, dot) = switch (status) {
      ActiveSessionStatus.active => (
        isDark ? AppColors.successBgDark : AppColors.successBg,
        isDark ? AppColors.successBorderDark : AppColors.successBorder,
        isDark ? AppColors.successTextDark : AppColors.successText,
        AppColors.success,
      ),
      ActiveSessionStatus.idle => (
        isDark ? AppColors.grayBgDark : AppColors.grayBg,
        isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        isDark ? AppColors.grayTextDark : AppColors.grayText,
        isDark ? AppColors.grayTextDark : AppColors.grayText,
      ),
      ActiveSessionStatus.locked => (
        isDark ? AppColors.errorBgDark : AppColors.errorBg,
        isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        isDark ? AppColors.errorTextDark : AppColors.errorText,
        AppColors.error,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ActiveSessionStatus.active) ...[_BlinkingDot(color: dot), Gap(8.w)],
          Text(
            status.label,
            style: context.textTheme.labelSmall?.copyWith(
              color: text,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  final Color color;

  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.25,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
