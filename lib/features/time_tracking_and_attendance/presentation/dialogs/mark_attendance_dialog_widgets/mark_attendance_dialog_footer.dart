import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceDialogFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const MarkAttendanceDialogFooter({super.key, required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!context.isMobile)
            AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: onCancel, height: 40.h),
          Gap(12.w),
          AppButton(
            label: 'Save Attendance',
            type: AppButtonType.primary,
            svgPath: Assets.icons.activeDepartmentsIcon.path,
            onPressed: onSave,
            height: 40.h,
          ),
        ],
      ),
    );
  }
}
