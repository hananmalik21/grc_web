import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginDesktopFooter extends ConsumerWidget {
  const LoginDesktopFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final backgroundColor = isDark ? context.themeCardBackground : Colors.white;
    final borderColor = isDark ? context.themeCardBorder : AppColors.cardBorder;
    final layout = ref.screenLayout;

    final items = <_LoginDesktopFooterItemData>[
      _LoginDesktopFooterItemData(
        assetPath: Assets.icons.leaveManagement.shield.path,
        title: localizations.loginDesktopFooterSecureAccessTitle,
        description: localizations.loginDesktopFooterSecureAccessDescription,
      ),
      _LoginDesktopFooterItemData(
        assetPath: Assets.icons.auth.star.path,
        title: localizations.loginDesktopFooterPermissionsTitle,
        description: localizations.loginDesktopFooterPermissionsDescription,
      ),
      _LoginDesktopFooterItemData(
        assetPath: Assets.icons.auth.flash.path,
        title: localizations.loginDesktopFooterAutomationTitle,
        description: localizations.loginDesktopFooterAutomationDescription,
      ),
      _LoginDesktopFooterItemData(
        assetPath: Assets.icons.analyticsIcon.path,
        title: localizations.loginDesktopFooterInsightsTitle,
        description: localizations.loginDesktopFooterInsightsDescription,
      ),
    ];

    final padding = context.responsiveFine(
      mobile: EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 20.w, 24.h),
      tabletSmall: EdgeInsetsDirectional.fromSTEB(32.w, 28.h, 32.w, 28.h),
      tabletMedium: EdgeInsetsDirectional.fromSTEB(40.w, 30.h, 40.w, 30.h),
      tabletLarge: EdgeInsetsDirectional.fromSTEB(46.w, 33.h, 46.w, 32.h),
      desktop: EdgeInsetsDirectional.fromSTEB(46.w, 33.h, 46.w, 32.h),
    );

    final maxContentWidth = context.responsiveFine(
      mobile: double.infinity,
      tabletSmall: 1100.w,
      tabletMedium: 1100.w,
      tabletLarge: 1250.w,
      desktop: 1280.w,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: _LoginDesktopFooterGrid(layout: layout, items: items),
          ),
        ),
      ),
    );
  }
}

class _LoginDesktopFooterGrid extends StatelessWidget {
  const _LoginDesktopFooterGrid({required this.layout, required this.items});

  final ScreenLayout layout;
  final List<_LoginDesktopFooterItemData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (layout) {
          ScreenLayout.desktop || ScreenLayout.tabletLarge => _fourColumnRow(),
          ScreenLayout.tabletMedium || ScreenLayout.tabletSmall => _twoColumnWrap(constraints.maxWidth),
          ScreenLayout.mobile => _singleColumn(),
        };
      },
    );
  }

  Widget _fourColumnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in items) Expanded(child: _LoginDesktopFooterItem(data: item))],
    );
  }

  Widget _twoColumnWrap(double maxWidth) {
    final itemWidth = (maxWidth - 24.w) / 2;

    return Wrap(
      spacing: 24.w,
      runSpacing: 24.h,
      children: [
        for (final item in items)
          SizedBox(
            width: itemWidth,
            child: _LoginDesktopFooterItem(data: item),
          ),
      ],
    );
  }

  Widget _singleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[if (i > 0) Gap(16.h), _LoginDesktopFooterItem(data: items[i])],
      ],
    );
  }
}

class _LoginDesktopFooterItemData {
  const _LoginDesktopFooterItemData({required this.assetPath, required this.title, required this.description});

  final String assetPath;
  final String title;
  final String description;
}

class _LoginDesktopFooterItem extends StatelessWidget {
  const _LoginDesktopFooterItem({required this.data});

  final _LoginDesktopFooterItemData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? context.themeTextPrimary : AppColors.authDesktopTitle;
    final descriptionColor = isDark ? context.themeTextSecondary : AppColors.authDesktopBody;
    final iconBackground = isDark ? AppColors.authBadgeBg.withValues(alpha: 0.2) : AppColors.authBadgeBorder;
    final iconColor = isDark ? AppColors.primaryLight : AppColors.primary;

    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.assetPath, width: 20.w, height: 20.h, color: iconColor),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: titleColor),
                ),
                Gap(4.h),
                Text(
                  data.description,
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: descriptionColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
