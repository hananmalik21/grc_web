import 'package:grc/core/services/responsive/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DeviceType { mobile, tablet, web }

class ResponsiveHelper {
  ResponsiveHelper._();

  static DeviceType getDeviceType(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile) return DeviceType.mobile;
    if (layout.isTablet) return DeviceType.tablet;
    return DeviceType.web;
  }

  static bool isMobile(BuildContext context) => getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;

  static bool isWeb(BuildContext context) => getDeviceType(context) == DeviceType.web;

  static double getResponsiveWidth(BuildContext context, {double? mobile, double? tablet, double? web}) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 100).w,
      DeviceType.tablet => (tablet ?? mobile ?? 100).w,
      DeviceType.web => (web ?? tablet ?? mobile ?? 100).w,
    };
  }

  static double getResponsiveHeight(BuildContext context, {double? mobile, double? tablet, double? web}) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 100).h,
      DeviceType.tablet => (tablet ?? mobile ?? 100).h,
      DeviceType.web => (web ?? tablet ?? mobile ?? 100).h,
    };
  }

  static double getResponsiveFontSize(BuildContext context, {double? mobile, double? tablet, double? web}) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 14).sp,
      DeviceType.tablet => (tablet ?? mobile ?? 14).sp,
      DeviceType.web => (web ?? tablet ?? mobile ?? 14).sp,
    };
  }

  static EdgeInsets getPagePadding(BuildContext context) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 12.h),
      DeviceType.tablet => EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 14.h),
      DeviceType.web => EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 14.h),
    };
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 24.h),
      DeviceType.tablet => EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 24.h),
      DeviceType.web => EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
    };
  }

  static EdgeInsets getDetailScreenPadding(BuildContext context) {
    return getScreenPadding(context).copyWith(top: 24.h);
  }

  static EdgeInsetsDirectional getResponsivePadding(
    BuildContext context, {
    EdgeInsetsDirectional? mobile,
    EdgeInsetsDirectional? tablet,
    EdgeInsetsDirectional? web,
  }) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => mobile ?? const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
      DeviceType.tablet => tablet ?? mobile ?? const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 16),
      DeviceType.web => web ?? tablet ?? mobile ?? const EdgeInsetsDirectional.symmetric(horizontal: 32, vertical: 20),
    };
  }

  static int getResponsiveColumns(BuildContext context, {int mobile = 1, int tablet = 2, int web = 3}) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet,
      DeviceType.web => web,
    };
  }

  static int getGridColumns(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isDesktop) return 4;
    if (layout.isTabletLarge) return 3;
    if (layout.isTablet) return 2;
    return 1;
  }

  static double getShiftCardExtent(BuildContext context) => isWeb(context) ? 360.0 : 360.h;

  static double getCardPadding(BuildContext context) => getResponsiveWidth(context, mobile: 12, tablet: 16, web: 24);

  static double getCardContentSpacing(BuildContext context) =>
      getResponsiveHeight(context, mobile: 10, tablet: 12, web: 16);

  static double getTabSectionSpacing(BuildContext context) =>
      getResponsiveHeight(context, mobile: 16, tablet: 20, web: 24);
}
