import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';

class AccessSectionCard extends StatelessWidget {
  const AccessSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.dashboardCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.isDark
                  ? AppColors.cardBackgroundDark
                  : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              border: Border(
                bottom: BorderSide(
                  color: context.isDark
                      ? AppColors.cardBorderDark
                      : AppColors.dashboardCardBorder,
                ),
              ),
            ),
            child: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.dialogTitle,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(14.r), child: child),
        ],
      ),
    );
  }
}
