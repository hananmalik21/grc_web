import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/config/sidebar_config.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ModuleSelectionHeader extends StatelessWidget {
  final SidebarItem module;
  final int childrenCount;
  final Color parentColor;

  const ModuleSelectionHeader({
    super.key,
    required this.module,
    required this.childrenCount,
    required this.parentColor,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title = SidebarConfig.getLocalizedLabel(module.labelKey, loc).replaceAll('\n', ' ');
    final isMobile = context.isMobileLayout;

    final headerRow = Row(
      children: [
        _CircularHeaderButton(onTap: () => context.go(AppRoutes.dashboard), icon: Icons.arrow_back_ios_new),
        Gap(isMobile ? 12.w : 21.w),
        Expanded(
          child: Row(
            children: [
              _ModuleIconBox(svgPath: module.svgPath ?? '', color: parentColor),
              Gap(isMobile ? 8.w : 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: (isMobile ? context.textTheme.titleLarge : context.textTheme.displaySmall)?.copyWith(
                        color: AppColors.dialogTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (module.subtitle != null)
                      Text(
                        module.subtitle!,
                        style: context.textTheme.labelLarge?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.grayBorderDark,
                          letterSpacing: 2.0,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) _FunctionalAreasBadge(count: childrenCount),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow,
          Gap(8.h),
          _FunctionalAreasBadge(count: childrenCount),
        ],
      );
    }
    return headerRow;
  }
}

class _ModuleIconBox extends StatelessWidget {
  final String svgPath;
  final Color color;

  const _ModuleIconBox({required this.svgPath, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.h,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14.r)),
      alignment: Alignment.center,
      child: DigifyAsset(assetPath: svgPath, width: 21.w, height: 21.h, color: AppColors.cardBackground),
    );
  }
}

class _FunctionalAreasBadge extends StatelessWidget {
  final int count;

  const _FunctionalAreasBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r), boxShadow: AppShadows.primaryShadow),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.w : 23.w, vertical: isMobile ? 9.h : 15.h),
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.cardBackground.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Text(
              '$count Functional Areas',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: isMobile ? 12.sp : 14.sp,
                color: AppColors.dashJobSchedules,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularHeaderButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const _CircularHeaderButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_back, size: 20.r, color: AppColors.textPrimary),
      ),
    );
  }
}
