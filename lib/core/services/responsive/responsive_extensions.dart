import 'package:flutter/material.dart';

import 'responsive_values.dart';

extension ResponsiveDataExtension on BuildContext {
  ResponsiveData get responsiveData => ResponsiveData.fromContext(this);

  bool get isMobile => responsiveData.isMobile;
  bool get isTablet => responsiveData.isTablet;
  bool get isDesktop => responsiveData.isDesktop;

  bool get isPortrait => responsiveData.isPortrait;
  bool get isLandscape => responsiveData.isLandscape;

  double get shortestSide => responsiveData.shortestSide;
  double get deviceWidth => responsiveData.width;
  double get deviceHeight => responsiveData.height;

  double get responsivePadding => responsiveData.padding;
  int get responsiveGridColumns => responsiveData.gridColumns;
  double get responsiveMaxContentWidth => responsiveData.maxContentWidth;
}
