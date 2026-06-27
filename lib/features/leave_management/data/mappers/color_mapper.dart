import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Maps color keys to actual Color values
class ColorMapper {
  static Color getColor(String colorKey) {
    switch (colorKey) {
      case 'infoBg':
        return AppColors.infoBg;
      case 'infoText':
        return AppColors.infoText;
      case 'infoTextSecondary':
        return AppColors.infoTextSecondary;
      case 'greenBg':
        return AppColors.greenBg;
      case 'greenText':
        return AppColors.greenText;
      case 'activeStatusTextLight':
        return AppColors.activeStatusTextLight;
      case 'pinkBackground':
        return AppColors.pinkBackground;
      case 'pinkTitleText':
        return AppColors.pinkTitleText;
      case 'pinkSubtitle':
        return AppColors.pinkSubtitle;
      case 'warningBg':
        return AppColors.warningBg;
      case 'yellowText':
        return AppColors.yellowText;
      case 'yellowSubtitle':
        return AppColors.yellowSubtitle;
      case 'sidebarFooterTitle':
        return AppColors.sidebarFooterTitle;
      case 'sidebarFooterSubtitle':
        return AppColors.sidebarFooterSubtitle;
      case 'greenTextSecondary':
        return AppColors.greenTextSecondary;
      case 'purpleBg':
        return AppColors.purpleBg;
      case 'purpleText':
        return AppColors.purpleText;
      case 'purpleTextSecondary':
        return AppColors.purpleTextSecondary;
      default:
        return Colors.grey;
    }
  }
}
