import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DepartmentField extends StatelessWidget {
  final TextEditingController controller;
  final AssignmentLevel? selectedLevel;
  final String? Function(String?)? validator;

  const DepartmentField({super.key, required this.controller, this.selectedLevel, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Select Department',
              style: TextStyle(
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                color: context.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
            Gap(4.w),
            Text(
              '*',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
            ),
          ],
        ),
        Gap(8.h),
        DigifyTextField(
          controller: controller,
          hintText: 'Type to search departments...',
          suffixIcon: DigifyAsset(assetPath: Assets.icons.arrowIcon.path, width: 18, height: 18),
          validator: validator,
        ),
        Gap(8.h),
        Text(
          'The schedule will be applied to all employees in the selected department',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: context.isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
