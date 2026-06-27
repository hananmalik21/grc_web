import 'package:grc/core/config/app_config.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/profile/profile_menu_config.dart';
import 'package:grc/core/navigation/profile/profile_menu_header.dart';
import 'package:grc/core/navigation/profile/profile_trigger.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HeaderProfileSection extends StatelessWidget {
  const HeaderProfileSection({
    super.key,
    required this.isDark,
    required this.layout,
    required this.localizations,
    this.onLogout,
  });

  final bool isDark;
  final ScreenLayout layout;
  final AppLocalizations localizations;
  final VoidCallback? onLogout;

  static const _name = AppConfig.placeholderUserName;
  static const _email = AppConfig.placeholderUserEmail;
  static const _role = AppConfig.placeholderUserRole;

  double get _avatarSize {
    if (layout.isDesktop || layout.isTabletLarge) return 30.0;
    if (layout.isTabletMedium) return 28.0;
    if (layout.isTabletSmall) return 26.0;
    return 24.0;
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = _avatarSize;
    final avatarIconSize = avatarSize * 0.6;

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.cardBackground,
          surfaceTintColor: AppColors.cardBackground,
          menuPadding: EdgeInsets.zero,
          textStyle: context.textTheme.bodyMedium?.copyWith(color: AppColors.textDarkSlate),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: '',
        offset: const Offset(0, 52),
        elevation: 20,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        constraints: BoxConstraints(minWidth: 260.w, maxWidth: 300.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        onSelected: (value) {
          if (value == 'logout') onLogout?.call();
        },
        itemBuilder: (context) => [
          _profileHeaderItem(),
          _spacer(),
          for (final item in ProfileMenuConfig.accountItems) ...[_buildMenuItem(context, item), _itemSpacer()],
          _divider(),
          for (final item in ProfileMenuConfig.systemItems) ...[_buildMenuItem(context, item), _itemSpacer()],
          _divider(),
          _buildMenuItem(context, ProfileMenuConfig.logoutItem.copyWith(label: localizations.logout)),
          _spacer(),
        ],
        child: ProfileTrigger(
          isDark: isDark,
          layout: layout,
          avatarSize: avatarSize,
          avatarIconSize: avatarIconSize,
          name: _name,
          role: _role,
        ),
      ),
    );
  }

  PopupMenuItem<String> _profileHeaderItem() {
    return PopupMenuItem<String>(
      enabled: false,
      padding: EdgeInsets.zero,
      child: ProfileMenuHeader(name: _name, email: _email, role: _role),
    );
  }

  PopupMenuItem<String> _spacer() {
    return PopupMenuItem<String>(enabled: false, height: 6.h, padding: EdgeInsets.zero, child: const SizedBox.shrink());
  }

  PopupMenuItem<String> _itemSpacer() {
    return PopupMenuItem<String>(enabled: false, height: 2.h, padding: EdgeInsets.zero, child: const SizedBox.shrink());
  }

  PopupMenuItem<String> _divider() {
    return PopupMenuItem<String>(
      enabled: false,
      height: 1,
      padding: EdgeInsets.zero,
      child: DigifyDivider.horizontal(indent: 12.w, endIndent: 12.w),
    );
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, ProfileMenuItem item) {
    final labelColor = item.isDestructive ? AppColors.error : AppColors.textDarkSlate;

    return PopupMenuItem<String>(
      value: item.value,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(color: item.iconBg, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: item.isSvg && item.iconPath != null
                ? DigifyAsset(assetPath: item.iconPath!, width: 15.r, height: 15.r, color: item.iconColor)
                : Icon(item.iconData, size: 15.sp, color: item.iconColor),
          ),
          Gap(12.w),
          Expanded(
            child: Text(item.label, style: context.textTheme.labelMedium?.copyWith(color: labelColor)),
          ),
          if (!item.isDestructive)
            DigifyAsset(
              assetPath: Assets.icons.workforce.chevronRight.path,
              width: 16.w,
              height: 16.h,
              color: AppColors.textPlaceholderDark,
            ),
        ],
      ),
    );
  }
}
