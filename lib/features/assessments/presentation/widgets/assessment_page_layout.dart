import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/widgets/app_horizontal_scroll_row.dart';

/// Shared responsive layout helpers for assessment feature pages.
abstract final class AssessmentPageLayout {
  AssessmentPageLayout._();

  static EdgeInsets pagePadding(BuildContext context) {
    final layout = context.screenLayout;
    if (layout.isMobile) {
      return EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 24.h);
    }
    if (layout.isCompact) {
      return ResponsiveHelper.getDetailScreenPadding(context);
    }
    return EdgeInsets.all(24.w);
  }

  static BoxConstraints contentConstraints(BuildContext context) {
    final compact = context.screenLayout.isCompact;
    return BoxConstraints(
      maxWidth: compact ? context.responsiveMaxContentWidth : 1512.w,
    );
  }

  static double sectionGap(BuildContext context) {
    return context.screenLayout.isCompact
        ? ResponsiveHelper.getTabSectionSpacing(context)
        : 24.h;
  }

  static double cardGap(BuildContext context) {
    return context.screenLayout.isCompact ? 16.h : 16.h;
  }

  static double cardPadding(BuildContext context) =>
      ResponsiveHelper.getCardPadding(context);

  static double titleFontSize(BuildContext context) {
    final layout = context.screenLayout;
    if (layout.isMobile) return 20.sp;
    if (layout.isTabletSmall) return 22.sp;
    return 24.sp;
  }

  static double subtitleFontSize(BuildContext context) {
    return context.screenLayout.isMobile ? 13.sp : 14.sp;
  }

  /// Horizontal scroll on compact; equal-width row on desktop.
  static Widget statsRow(BuildContext context, List<Widget> cards) {
    final layout = context.screenLayout;
    if (layout.isCompact) {
      final cardWidth = layout.isMobile
          ? MediaQuery.sizeOf(context).width * 0.86
          : ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 220,
              tablet: 240,
              web: 260,
            );

      return AppHorizontalScrollRow(
        spacing: context.responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0),
        children: [
          for (final card in cards) SizedBox(width: cardWidth, child: card),
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) SizedBox(width: 16.w),
        ],
      ],
    );
  }

  /// Single column on compact; 2-column grid on desktop.
  static Widget twoColumnGrid(
    BuildContext context, {
    required List<Widget> children,
    double columnGap = 16,
    double rowGap = 16,
  }) {
    final layout = context.screenLayout;

    if (layout.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(height: rowGap.h),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final right = i + 1 < children.length ? children[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              SizedBox(width: columnGap.w),
              Expanded(
                child: right ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < children.length) rows.add(SizedBox(height: rowGap.h));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  /// Back + title row; trailing action stacks below on compact.
  static Widget detailTitleBar({
    required BuildContext context,
    required Widget backButton,
    required Widget titleSection,
    required Widget trailing,
  }) {
    final layout = context.screenLayout;

    if (layout.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              backButton,
              SizedBox(width: 16.w),
              Expanded(child: titleSection),
            ],
          ),
          SizedBox(height: 16.h),
          trailing,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        backButton,
        SizedBox(width: 16.w),
        Expanded(child: titleSection),
        SizedBox(width: 16.w),
        trailing,
      ],
    );
  }

  /// Side-by-side tabs on wide screens; stacked on mobile.
  static Widget tabSwitcher({
    required BuildContext context,
    required List<Widget> tabs,
    double gap = 8,
  }) {
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            tabs[i],
            if (i != tabs.length - 1) SizedBox(height: gap.h),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < tabs.length; i++) ...[
          Expanded(child: tabs[i]),
          if (i != tabs.length - 1) SizedBox(width: gap.w),
        ],
      ],
    );
  }
}
