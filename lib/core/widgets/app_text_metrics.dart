import 'package:flutter/material.dart';

class AppTextMetrics {
  const AppTextMetrics._();

  static const textHeight = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  static StrutStyle strut({
    required double fontSize,
    required double lineHeight,
  }) {
    return StrutStyle(
      fontSize: fontSize,
      height: lineHeight / fontSize,
      forceStrutHeight: true,
    );
  }
}
