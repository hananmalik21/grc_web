import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({super.key, required this.themeMode, required this.onToggle, this.isDark = false});

  final ThemeMode themeMode;
  final VoidCallback onToggle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isLightSelected = themeMode == ThemeMode.light;
    final trackColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
    final selectedBg = isDark ? AppColors.primaryDark : AppColors.primary;
    final unselectedColor = isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
    const selectedColor = Colors.white;

    const double hPad = 4.0;
    final double trackW = context.responsiveFine(
      mobile: 58.0,
      tabletSmall: 62.0,
      tabletMedium: 66.0,
      tabletLarge: 70.0,
      desktop: 74.0,
    );
    final double trackH = context.responsiveFine(
      mobile: 26.0,
      tabletSmall: 27.0,
      tabletMedium: 28.0,
      tabletLarge: 29.0,
      desktop: 30.0,
    );
    final double slotW = context.responsiveFine(
      mobile: 23.0,
      tabletSmall: 25.0,
      tabletMedium: 27.0,
      tabletLarge: 28.0,
      desktop: 30.0,
    );
    final double slotOffset = hPad + slotW;
    final double iconSize = context.responsiveFine(
      mobile: 14.0,
      tabletSmall: 15.0,
      tabletMedium: 16.0,
      tabletLarge: 17.0,
      desktop: 18.0,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: trackW,
          height: trackH,
          padding: const EdgeInsets.symmetric(horizontal: hPad),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey, width: 1),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: isLightSelected ? 0 : slotOffset,
                top: 3,
                bottom: 3,
                child: Container(
                  width: slotW,
                  decoration: BoxDecoration(color: selectedBg, borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
              Positioned(
                top: 3,
                bottom: 3,
                width: slotW,
                child: Center(
                  child: Icon(
                    Icons.light_mode_rounded,
                    size: iconSize,
                    color: isLightSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
              Positioned(
                left: slotOffset,
                top: 3,
                bottom: 3,
                width: slotW,
                child: Center(
                  child: Icon(
                    Icons.dark_mode_rounded,
                    size: iconSize,
                    color: isLightSelected ? unselectedColor : selectedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
