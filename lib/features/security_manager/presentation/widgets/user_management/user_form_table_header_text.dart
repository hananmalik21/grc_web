import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class UserFormTableHeaderText extends StatelessWidget {
  final String text;
  final int flex;
  final bool isDark;

  const UserFormTableHeaderText({
    super.key,
    required this.text,
    required this.flex,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
