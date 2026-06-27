import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HeaderNotificationIcon extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final bool isDark;

  const HeaderNotificationIcon({super.key, required this.count, this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveFine(
      mobile: 18.0,
      tabletSmall: 18.0,
      tabletMedium: 19.0,
      tabletLarge: 19.0,
      desktop: 20.0,
    );
    final double badgeSize = context.responsiveFine(
      mobile: 13.0,
      tabletSmall: 13.0,
      tabletMedium: 13.0,
      tabletLarge: 14.0,
      desktop: 14.0,
    );
    final double badgeFontSize = context.responsiveFine(
      mobile: 9.0,
      tabletSmall: 9.0,
      tabletMedium: 9.0,
      tabletLarge: 10.0,
      desktop: 10.0,
    );
    final double iconPadding = context.responsiveFine(
      mobile: 4.0,
      tabletSmall: 4.0,
      tabletMedium: 4.0,
      tabletLarge: 5.0,
      desktop: 6.0,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DigifyAssetButton(
          onTap: onTap,
          assetPath: Assets.icons.header.notificationBell.path,
          width: iconSize,
          height: iconSize,
          color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
          padding: iconPadding,
        ),
        if (count > 0)
          Positioned(
            right: 3,
            top: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              constraints: BoxConstraints(minWidth: badgeSize, minHeight: badgeSize),
              decoration: BoxDecoration(
                color: AppColors.deleteIconRed,
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: badgeFontSize,
                  color: AppColors.cardBackground,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
