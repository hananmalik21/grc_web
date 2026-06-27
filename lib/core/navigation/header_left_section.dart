import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderLeftSection extends StatelessWidget {
  const HeaderLeftSection({
    super.key,
    required this.layout,
    required this.isDark,
    required this.onMenuTap,
    this.isSidebarExpanded = false,
    this.onLogoTap,
  });

  final ScreenLayout layout;
  final bool isDark;
  final bool isSidebarExpanded;
  final VoidCallback onMenuTap;
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveFine(
      mobile: 18.0,
      tabletSmall: 18.0,
      tabletMedium: 20.0,
      tabletLarge: 20.0,
      desktop: 20.0,
    );
    final double menuPadding = context.responsive(mobile: 4.0.r, desktop: 6.0.r);
    final double logoHeight = context.responsiveFine(
      mobile: 20.0.h,
      tabletSmall: 20.0.h,
      tabletMedium: 22.0.h,
      tabletLarge: 24.0.h,
      desktop: 25.0.h,
    );
    final Color iconColor = isDark ? AppColors.textPrimaryDark : AppColors.lightDark;

    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onMenuTap,
          child: Container(
            padding: EdgeInsets.all(menuPadding),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
            child: isSidebarExpanded
                ? DigifyAsset(
                    assetPath: Assets.icons.closeIcon.path,
                    width: iconSize.w,
                    height: iconSize.h,
                    color: iconColor,
                  )
                : DigifyAsset(assetPath: Assets.icons.menuToggleIcon.path, height: iconSize.h, color: iconColor),
          ),
        ),
        if (!isSidebarExpanded) ...[
          if (onLogoTap != null)
            InkWell(
              onTap: onLogoTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(menuPadding),
                child: DigifyAsset(
                  assetPath: isDark ? Assets.logo.digifyLogoDark.path : Assets.logo.digifyLogo.path,
                  height: logoHeight,
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(menuPadding),
              child: DigifyAsset(
                assetPath: isDark ? Assets.logo.digifyLogoDark.path : Assets.logo.digifyLogo.path,
                height: logoHeight,
              ),
            ),
        ],
      ],
    );
  }
}
