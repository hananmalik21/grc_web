import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;

  const LoginCheckbox({super.key, required this.value, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!value),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 17.0,
            height: 17.0,
            decoration: BoxDecoration(
              color: value ? AppColors.authButton : AppColors.authDivider,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(color: value ? AppColors.authButton : AppColors.authInputBorder, width: 1),
            ),
            child: value ? Icon(Icons.check_rounded, size: 14.sp, color: Colors.white) : null,
          ),
          Gap(10.5.w),
          Text(
            label.toUpperCase(),
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: 10.sp,
              color: AppColors.authLinkText,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
