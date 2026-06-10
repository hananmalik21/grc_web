import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';

enum DeviceType { mobile, tablet, web }

class ResponsiveHelper {
  ResponsiveHelper._();

  static DeviceType getDeviceType(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile) return DeviceType.mobile;
    if (layout.isTablet) return DeviceType.tablet;
    return DeviceType.web;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isWeb(BuildContext context) =>
      getDeviceType(context) == DeviceType.web;

  static double getResponsiveWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 100).w,
      DeviceType.tablet => (tablet ?? mobile ?? 100).w,
      DeviceType.web => (web ?? tablet ?? mobile ?? 100).w,
    };
  }

  static double getResponsiveHeight(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 100).h,
      DeviceType.tablet => (tablet ?? mobile ?? 100).h,
      DeviceType.web => (web ?? tablet ?? mobile ?? 100).h,
    };
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => (mobile ?? 14).sp,
      DeviceType.tablet => (tablet ?? mobile ?? 14).sp,
      DeviceType.web => (web ?? tablet ?? mobile ?? 14).sp,
    };
  }

  static EdgeInsets getPagePadding(BuildContext context) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => EdgeInsets.symmetric(
        horizontal: 16.w,
      ).copyWith(top: 12.h),
      DeviceType.tablet => EdgeInsets.symmetric(
        horizontal: 20.w,
      ).copyWith(top: 14.h),
      DeviceType.web => EdgeInsets.symmetric(
        horizontal: 24.w,
      ).copyWith(top: 14.h),
    };
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    return switch (getDeviceType(context)) {
      DeviceType.mobile => EdgeInsets.symmetric(
        horizontal: 16.w,
      ).copyWith(bottom: 24.h),
      DeviceType.tablet => EdgeInsets.symmetric(
        horizontal: 20.w,
      ).copyWith(bottom: 24.h),
      DeviceType.web => EdgeInsets.symmetric(
        horizontal: 24.w,
      ).copyWith(bottom: 24.h),
    };
  }

  static EdgeInsets getDetailScreenPadding(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isTabletSmall) {
      return EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h);
    }
    if (layout.isMobile) {
      return EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h);
    }
    final top = layout.isCompact ? 12.h : 24.h;
    return getScreenPadding(context).copyWith(top: top);
  }

  static bool isCompactLayout(BuildContext context) =>
      AppBreakpoints.fromContext(context).isCompact;

  static int getResponsiveColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int web = 3,
  }) {
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

  static double getCardPadding(BuildContext context) =>
      getResponsiveWidth(context, mobile: 16, tablet: 20, web: 25);

  static double getTabSectionSpacing(BuildContext context) =>
      getResponsiveHeight(context, mobile: 20, tablet: 20, web: 24);

  /// Width below which stacked / scroll layouts replace multi-column desktop rows.
  static const double narrowContentWidth = 1100;

  static bool isNarrowWidth(double width) => width < narrowContentWidth;

  static EdgeInsets libraryCardPadding(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    if (layout.isMobile || layout.isTabletSmall) return EdgeInsets.all(16.w);
    if (layout.isCompact) return EdgeInsets.all(14.w);
    return EdgeInsets.all(17.w);
  }

  static double fieldLabelSpacing(BuildContext context) =>
      AppBreakpoints.fromContext(context).isMobile ? 10.h : 8.h;
}
