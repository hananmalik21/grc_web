import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primaryHorizontal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [AppColors.primaryLight, AppColors.primary],
  );

  static const LinearGradient primaryLeftToRight = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primaryLight, AppColors.primary],
  );

  static const LinearGradient primaryDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryLight, AppColors.gradientBlue],
  );

  static const LinearGradient primaryToPurple = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, Color(0xFF9810FA)],
  );

  static const LinearGradient primaryToPurpleDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, Color(0xFF9810FA)],
  );

  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD1FAE5), AppColors.success],
  );

  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.warningBg, AppColors.warning],
  );

  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.errorBg, AppColors.error],
  );

  static const LinearGradient info = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.infoBg, AppColors.info],
  );

  static const LinearGradient purple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.purpleBg, AppColors.purple],
  );

  static LinearGradient custom({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    required List<Color> colors,
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors);
  }
}
