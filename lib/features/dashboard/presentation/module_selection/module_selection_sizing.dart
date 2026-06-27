import 'dart:math' as math;

import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';

enum DialogBreakpoint { mobile, tablet, desktop }

class DialogSizing {
  final double dialogWidth;
  final double dialogHeight;
  final double outerPadding;
  final double gap;
  final double cardWidth;
  final double cardHeight;
  final int columns;
  final WrapAlignment wrapAlignment;
  final DialogBreakpoint breakpoint;

  DialogSizing({
    required this.dialogWidth,
    required this.dialogHeight,
    required this.outerPadding,
    required this.gap,
    required this.cardWidth,
    required this.cardHeight,
    required this.columns,
    required this.wrapAlignment,
    required this.breakpoint,
  });

  factory DialogSizing.calculate(BuildContext context) {
    final layout = context.screenLayout;
    final bp = _layoutToBreakpoint(layout);
    final size = MediaQuery.sizeOf(context);
    final maxWidth = size.width.clamp(320.0, 1800.0);
    final maxHeight = size.height;

    final cardW = context.responsiveFine<double>(
      mobile: 140.0,
      tabletSmall: 175.0,
      tabletMedium: 185.0,
      tabletLarge: 210.0,
      desktop: 230.0,
    );
    final cardH = context.responsiveFine<double>(
      mobile: 170.0,
      tabletSmall: 200.0,
      tabletMedium: 210.0,
      tabletLarge: 235.0,
      desktop: 250.0,
    );
    final outerPad = context.responsive<double>(mobile: 12.0, tablet: 24.0, desktop: 32.0);
    final gap = context.responsiveFine<double>(
      mobile: 8.0,
      tabletSmall: 12.0,
      tabletMedium: 16.0,
      tabletLarge: 18.0,
      desktop: 20.0,
    );

    final dialogW = layout.isMobile
        ? math.min(maxWidth * 0.95, maxWidth - 32)
        : math.min(maxWidth, 1200.0);
    final dialogH = math.min(maxHeight * 0.9, 647.0);

    final availableGridW = dialogW - (outerPad * 2);
    final minCols = layout.isMobile ? 1 : 2;
    final cols = ((availableGridW + gap) / (cardW + gap)).floor().clamp(minCols, 4);

    return DialogSizing(
      dialogWidth: dialogW,
      dialogHeight: dialogH,
      outerPadding: outerPad,
      gap: gap,
      cardWidth: cardW,
      cardHeight: cardH,
      columns: cols,
      wrapAlignment: WrapAlignment.start,
      breakpoint: bp,
    );
  }

  static DialogBreakpoint _layoutToBreakpoint(ScreenLayout layout) => switch (layout) {
    ScreenLayout.mobile => DialogBreakpoint.mobile,
    ScreenLayout.tabletSmall ||
    ScreenLayout.tabletMedium ||
    ScreenLayout.tabletLarge =>
      DialogBreakpoint.tablet,
    ScreenLayout.desktop => DialogBreakpoint.desktop,
  };
}
