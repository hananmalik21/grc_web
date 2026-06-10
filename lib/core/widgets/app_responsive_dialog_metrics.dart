import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/services/responsive/breakpoints.dart';

/// Layout modes derived from the dialog's **available width**, not the viewport alone.
enum AppDialogLayoutMode {
  /// < 640px — full-width stacked UI
  phone,

  /// 640px – [dialogWideMinWidth) — compact but not phone
  compact,

  /// >= [dialogWideMinWidth] — original desktop dialog layout
  wide,
}

/// Shared sizing and layout helpers for modal dialogs across breakpoints.
class AppResponsiveDialogMetrics {
  AppResponsiveDialogMetrics({
    required this.context,
    required this.dialogWidth,
    required this.dialogHeight,
    this.wideMinWidth = dialogWideMinWidth,
  });

  factory AppResponsiveDialogMetrics.fromContext(
    BuildContext context, {
    required double dialogWidth,
    required double dialogHeight,
    double? wideMinWidth,
  }) {
    return AppResponsiveDialogMetrics(
      context: context,
      dialogWidth: dialogWidth,
      dialogHeight: dialogHeight,
      wideMinWidth: wideMinWidth ?? dialogWideMinWidth,
    );
  }

  final BuildContext context;
  final double dialogWidth;
  final double dialogHeight;
  final double wideMinWidth;

  static const double maxDialogWidth = 936;

  /// Dialog content fits side-by-side rows at this width and above.
  static const double dialogWideMinWidth = 800;

  /// Smaller dialogs (e.g. add asset at 672px) use a lower wide threshold.
  static const double compactDialogWideMinWidth = 560;

  static EdgeInsets insetPaddingForViewport(double viewportWidth) {
    if (viewportWidth < AppBreakpoints.mobile) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    }
    if (viewportWidth < AppBreakpoints.tabletSmall) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    }
    if (viewportWidth < AppBreakpoints.tabletMedium) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
  }

  static AppDialogLayoutMode layoutModeForWidth(
    double width, {
    double wideMinWidth = dialogWideMinWidth,
  }) {
    if (width < 640) return AppDialogLayoutMode.phone;
    if (width < wideMinWidth) return AppDialogLayoutMode.compact;
    return AppDialogLayoutMode.wide;
  }

  AppDialogLayoutMode get layoutMode =>
      layoutModeForWidth(dialogWidth, wideMinWidth: wideMinWidth);

  bool get isPhone => layoutMode == AppDialogLayoutMode.phone;
  bool get isCompact => layoutMode == AppDialogLayoutMode.compact;
  bool get isWide => layoutMode == AppDialogLayoutMode.wide;

  /// Stack primary/secondary actions vertically (phone + compact dialog widths).
  bool get useStackedActions => !isWide;

  /// Stack footer buttons vertically (phone only).
  bool get useStackedFooter => isPhone;

  /// Category cards with actions above content (phone + compact).
  bool get useStackedCategoryCard => !isWide;

  EdgeInsets get contentPadding => isPhone
      ? EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h)
      : isCompact
          ? EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h)
          : EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h);

  EdgeInsets get headerPadding => isPhone
      ? EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 15.h)
      : EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h);

  EdgeInsets get footerPadding => isPhone
      ? EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h)
      : EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 16.h);

  double get sectionGap => isPhone ? 16.h : (isCompact ? 20.h : 24.h);

  double get cardGap => isPhone ? 10.h : 12.h;

  double get fieldGap => isPhone ? 12.h : 16.h;

  double get majorSectionGap => isPhone ? 24.h : (isCompact ? 28.h : 32.h);

  double get maxHeight => isPhone
      ? dialogHeight
      : math.min(dialogHeight, dialogHeight * 0.92);
}
