import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RolesManagementSurfaceCard extends StatelessWidget {
  const RolesManagementSurfaceCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class RolesManagementSectionCard extends StatelessWidget {
  const RolesManagementSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return RolesManagementSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 55.h,
            padding: EdgeInsets.symmetric(horizontal: 14.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
              border: Border(
                bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: _SectionTitle(title: title)),
                ?trailing,
              ],
            ),
          ),
          Padding(padding: padding ?? EdgeInsets.all(14.r), child: child),
        ],
      ),
    );
  }
}

class RolesManagementFieldLabel extends StatelessWidget {
  const RolesManagementFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleSmall?.copyWith(
        color: context.isDark ? context.themeTextPrimary : AppColors.inputLabel,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      ],
    );
  }
}
