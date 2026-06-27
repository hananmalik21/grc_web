import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const LabeledField({super.key, required this.label, required this.child, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.55,
                  color: AppColors.sidebarSecondaryText,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.55,
                    color: AppColors.alertCritical,
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        child,
      ],
    );
  }
}

class ReadOnlyField extends StatelessWidget {
  final String value;
  final String? hintText;

  const ReadOnlyField({super.key, required this.value, this.hintText});

  @override
  Widget build(BuildContext context) {
    return DigifyTextField(
      initialValue: value.isEmpty ? null : value,
      hintText: value.isEmpty ? (hintText ?? '--') : null,
      enabled: false,
      filled: true,
      fillColor: AppColors.sidebarSearchBg,
      borderColor: context.themeCardBorder,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      fontSize: 14.sp,
    );
  }
}

class PrimarySoftButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  const PrimarySoftButton({super.key, required this.label, required this.iconPath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: AppColors.onPrimary),
        label: Text(
          label,
          style: context.labelLarge.copyWith(fontSize: 14.sp, color: AppColors.onPrimary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          elevation: 0,
        ),
      ),
    );
  }
}
