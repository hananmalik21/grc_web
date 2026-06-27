import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Represents a single entry in the profile popup menu.
class ProfileMenuItem {
  const ProfileMenuItem({
    required this.value,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    this.iconPath,
    this.iconData,
    this.isSvg = false,
    this.isDestructive = false,
  }) : assert(
         iconPath != null || iconData != null,
         'Provide either iconPath or iconData',
       );

  final String value;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final String? iconPath;
  final IconData? iconData;
  final bool isSvg;

  /// When true: text renders in error red, chevron hidden.
  final bool isDestructive;

  ProfileMenuItem copyWith({String? label}) {
    return ProfileMenuItem(
      value: value,
      label: label ?? this.label,
      iconBg: iconBg,
      iconColor: iconColor,
      iconPath: iconPath,
      iconData: iconData,
      isSvg: isSvg,
      isDestructive: isDestructive,
    );
  }
}

/// Groups of profile menu items separated by dividers.
class ProfileMenuConfig {
  ProfileMenuConfig._();

  /// Account-related actions (first group).
  static final List<ProfileMenuItem> accountItems = [
    ProfileMenuItem(
      value: 'profile',
      label: 'My Profile',
      iconPath: Assets.icons.userIcon.path,
      isSvg: true,
      iconBg: AppColors.infoBg,
      iconColor: AppColors.primary,
    ),
    ProfileMenuItem(
      value: 'change_password',
      label: 'Change Password',
      iconPath: Assets.icons.lockIcon.path,
      isSvg: true,
      iconBg: AppColors.successBg,
      iconColor: AppColors.success,
    ),
  ];

  /// System-related actions (second group).
  static final List<ProfileMenuItem> systemItems = [
    ProfileMenuItem(
      value: 'desktop_tabs',
      label: 'Manage Desktop Tabs',
      iconData: Icons.folder_open_outlined,
      iconBg: AppColors.purpleBg,
      iconColor: AppColors.purple,
    ),
    ProfileMenuItem(
      value: 'system_settings',
      label: 'System Settings',
      iconData: Icons.dns_outlined,
      iconBg: AppColors.grayBg,
      iconColor: AppColors.grayText,
    ),
    ProfileMenuItem(
      value: 'settings',
      label: 'Settings',
      iconPath: Assets.icons.settingsIcon.path,
      isSvg: true,
      iconBg: AppColors.orangeBg,
      iconColor: AppColors.orange,
    ),
  ];

  /// Destructive action shown at the bottom.
  static const ProfileMenuItem logoutItem = ProfileMenuItem(
    value: 'logout',
    label: 'Sign Out',
    iconData: Icons.logout_rounded,
    iconBg: AppColors.errorBg,
    iconColor: AppColors.error,
    isDestructive: true,
  );
}
