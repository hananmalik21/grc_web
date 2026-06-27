import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;
  final bool isDark;

  const HeaderSearchField({super.key, required this.controller, this.hintText, this.onSubmitted, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = isDark ? AppColors.inputBorderDark : AppColors.inputBorder;

    final double fontSize = context.responsiveFine(
      mobile: 13.0.sp,
      tabletSmall: 13.0.sp,
      tabletMedium: 13.5.sp,
      tabletLarge: 14.0.sp,
      desktop: 14.0.sp,
    );
    final double verticalPadding = context.responsiveFine(
      mobile: 11.0.h,
      tabletSmall: 11.0.h,
      tabletMedium: 12.0.h,
      tabletLarge: 13.0.h,
      desktop: 15.0.h,
    );

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 12.w),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: isDark ? context.themeTextMuted : const Color(0xFF94A3B8),
        ),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
          child: DigifyAsset(
            assetPath: Assets.icons.searchIcon.path,
            width: 18,
            height: 18,
            color: isDark ? context.themeTextMuted : AppColors.tableHeaderText,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
        border: _buildBorder(effectiveBorderColor),
        enabledBorder: _buildBorder(effectiveBorderColor),
        focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
      ),
    );
  }

  InputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: width.w),
    );
  }
}
