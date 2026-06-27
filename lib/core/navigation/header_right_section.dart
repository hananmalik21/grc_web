import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/theme_mode_toggle.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/navigation/header_notification_icon.dart';
import 'package:grc/core/navigation/header_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HeaderRightSection extends StatelessWidget {
  const HeaderRightSection({
    super.key,
    required this.layout,
    required this.isDark,
    required this.themeMode,
    required this.locale,
    required this.localizations,
    required this.onToggleTheme,
    required this.onToggleLocale,
    this.onLogout,
  });

  final ScreenLayout layout;
  final bool isDark;
  final ThemeMode themeMode;
  final Locale locale;
  final AppLocalizations localizations;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final bool showLanguage = layout.isDesktop;
    final bool showHelpFav = layout.isDesktop;
    final double itemGap = context.responsiveFine(
      mobile: 8.0,
      tabletSmall: 8.0,
      tabletMedium: 10.0,
      tabletLarge: 12.0,
      desktop: 14.0,
    );
    final double iconSize = context.responsiveFine(
      mobile: 18.0,
      tabletSmall: 18.0,
      tabletMedium: 19.0,
      tabletLarge: 19.0,
      desktop: 20.0,
    );
    final Color iconColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLanguage) ...[
          _LanguageButton(
            locale: locale,
            isDark: isDark,
            iconColor: iconColor,
            showLabel: layout.isDesktop,
            onTap: onToggleLocale,
          ),
          Gap(itemGap),
        ],
        ThemeModeToggle(themeMode: themeMode, isDark: isDark, onToggle: onToggleTheme),
        Gap(itemGap),
        if (showHelpFav) ...[
          DigifyAssetButton(
            onTap: () {},
            assetPath: Assets.icons.header.help.path,
            width: iconSize,
            height: iconSize,
            color: iconColor,
          ),
          Gap(itemGap),
          DigifyAssetButton(
            onTap: () {},
            assetPath: Assets.icons.header.favourite.path,
            width: iconSize,
            height: iconSize,
            color: iconColor,
          ),
          Gap(itemGap),
        ],
        HeaderNotificationIcon(count: 2, isDark: isDark, onTap: () {}),
        DigifyVerticalDivider.standard(
          thickness: 2,
          margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: itemGap),
        ),
        HeaderProfileSection(isDark: isDark, layout: layout, localizations: localizations, onLogout: onLogout),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.locale,
    required this.isDark,
    required this.iconColor,
    required this.showLabel,
    required this.onTap,
  });

  final Locale locale;
  final bool isDark;
  final Color iconColor;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveFine(
      mobile: 18.0,
      tabletSmall: 18.0,
      tabletMedium: 19.0,
      tabletLarge: 19.0,
      desktop: 20.0,
    );
    final double fontSize = context.responsiveFine(
      mobile: 13.0,
      tabletSmall: 13.0,
      tabletMedium: 13.0,
      tabletLarge: 14.0,
      desktop: 15.0,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.header.language.path,
                width: iconSize,
                height: iconSize,
                color: iconColor,
              ),
              if (showLabel) ...[
                const Gap(6),
                Text(
                  locale.languageCode.toUpperCase(),
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: iconColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
