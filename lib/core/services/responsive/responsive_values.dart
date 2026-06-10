import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveData {
  final double width;
  final double height;
  final double shortestSide;
  final Orientation orientation;
  final ScreenLayout layout;

  const ResponsiveData({
    required this.width,
    required this.height,
    required this.shortestSide,
    required this.orientation,
    required this.layout,
  });

  factory ResponsiveData.fromContext(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return ResponsiveData(
      width: size.width,
      height: size.height,
      shortestSide: size.shortestSide,
      orientation: orientation,
      layout: AppBreakpoints.fromShortestSide(size.shortestSide),
    );
  }

  bool get isMobile => layout.isMobile;
  bool get isTablet => layout.isTablet;
  bool get isDesktop => layout.isDesktop;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  double get padding {
    switch (layout) {
      case ScreenLayout.mobile:
        return 12;
      case ScreenLayout.tabletSmall:
        return 18;
      case ScreenLayout.tabletMedium:
        return 20;
      case ScreenLayout.tabletLarge:
        return 24;
      case ScreenLayout.desktop:
        return 28;
    }
  }

  int get gridColumns {
    switch (layout) {
      case ScreenLayout.mobile:
        return 1;
      case ScreenLayout.tabletSmall:
        return 2;
      case ScreenLayout.tabletMedium:
        return 2;
      case ScreenLayout.tabletLarge:
        return 3;
      case ScreenLayout.desktop:
        return 4;
    }
  }

  double get maxContentWidth {
    switch (layout) {
      case ScreenLayout.mobile:
        return width;
      case ScreenLayout.tabletSmall:
      case ScreenLayout.tabletMedium:
        return 1100;
      case ScreenLayout.tabletLarge:
        return 1250;
      case ScreenLayout.desktop:
        return 1512;
    }
  }

  bool get isSideBySide => layout.isSideBySide;
}
