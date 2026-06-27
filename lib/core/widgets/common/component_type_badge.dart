import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/enterprise_structure/domain/models/component_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Badge showing component type with color coding
class ComponentTypeBadge extends StatelessWidget {
  final ComponentType type;
  final String? customLabel;
  final String? iconPath;

  const ComponentTypeBadge({super.key, required this.type, this.customLabel, this.iconPath});

  String _getLabel() {
    if (customLabel != null) return customLabel!;
    switch (type) {
      case ComponentType.company:
        return 'Company';
      case ComponentType.division:
        return 'Division';
      case ComponentType.businessUnit:
        return 'Business Unit';
      case ComponentType.department:
        return 'Department';
      case ComponentType.section:
        return 'Section';
    }
  }

  Color _getBackgroundColor(bool isDark) {
    switch (type) {
      case ComponentType.company:
        return isDark ? AppColors.infoBgDark : AppColors.infoBg;
      case ComponentType.division:
        return isDark ? AppColors.purpleBgDark : AppColors.purpleBg;
      case ComponentType.businessUnit:
        return isDark ? AppColors.warningBgDark : AppColors.warningBg;
      case ComponentType.department:
        return isDark ? AppColors.successBgDark : AppColors.successBg;
      case ComponentType.section:
        return isDark ? AppColors.orangeBg : AppColors.orangeBg;
    }
  }

  Color _getBorderColor(bool isDark) {
    switch (type) {
      case ComponentType.company:
        return isDark ? AppColors.infoBorderDark : AppColors.infoBorder;
      case ComponentType.division:
        return isDark ? AppColors.purpleBorderDark : AppColors.purpleBorder;
      case ComponentType.businessUnit:
        return isDark ? AppColors.warningBorderDark : AppColors.warningBorder;
      case ComponentType.department:
        return isDark ? AppColors.successBorderDark : AppColors.successBorder;
      case ComponentType.section:
        return isDark ? AppColors.orangeBorder : AppColors.orangeBorder;
    }
  }

  Color _getTextColor(bool isDark) {
    switch (type) {
      case ComponentType.company:
        return isDark ? AppColors.infoTextDark : AppColors.infoText;
      case ComponentType.division:
        return isDark ? AppColors.purpleTextDark : AppColors.purpleText;
      case ComponentType.businessUnit:
        return isDark ? AppColors.warningTextDark : AppColors.warningText;
      case ComponentType.department:
        return isDark ? AppColors.successTextDark : AppColors.successText;
      case ComponentType.section:
        return isDark ? AppColors.orangeText : AppColors.orangeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isDark),
        border: Border.all(color: _getBorderColor(isDark), width: 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            DigifyAsset(assetPath: iconPath!, width: 14, height: 14, color: _getTextColor(isDark)),
            SizedBox(width: 6.w),
          ],
          Text(
            _getLabel(),
            style: TextStyle(
              fontSize: 12.6.sp,
              fontWeight: FontWeight.w500,
              color: _getTextColor(isDark),
              height: 18 / 12.6,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
