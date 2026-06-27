import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_text_theme.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceDialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const MarkAttendanceDialogHeader({super.key, required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.sidebar.scheduleAssignments.path,
            width: 18.w,
            height: 18.h,
            color: Colors.white,
          ),
          Gap(4.w),
          Expanded(
            child: Text(
              title,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.cancel_outlined, size: 20.r, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
