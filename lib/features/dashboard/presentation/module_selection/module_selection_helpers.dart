import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_buttons_helper.dart';
import 'package:flutter/material.dart';

SidebarItem? resolveModuleForSelection(String moduleId, List<SidebarItem> sidebarItems) {
  try {
    return sidebarItems.firstWhere((item) => item.id == moduleId);
  } catch (_) {
    final camelId = kebabToCamel(moduleId);
    try {
      return sidebarItems.firstWhere((item) => item.id == camelId);
    } catch (_) {
      if (moduleId == 'settings') {
        try {
          return sidebarItems.firstWhere((item) => item.id == 'settingsConfig');
        } catch (_) {}
      }
    }
  }
  return null;
}

String kebabToCamel(String input) {
  if (!input.contains('-')) return input;
  final parts = input.split('-');
  final buffer = StringBuffer(parts[0]);
  for (var i = 1; i < parts.length; i++) {
    final part = parts[i];
    if (part.isNotEmpty) {
      buffer.write(part[0].toUpperCase() + part.substring(1));
    }
  }
  return buffer.toString();
}

Color parentColorForModule(String moduleId, AppLocalizations loc) {
  final buttons = getDashboardButtons(loc);
  try {
    return buttons.firstWhere((b) => b.id == moduleId).color;
  } catch (_) {
    final camelId = kebabToCamel(moduleId);
    try {
      return buttons.firstWhere((b) => b.id == camelId).color;
    } catch (_) {
      if (moduleId == 'settings') {
        try {
          return buttons.firstWhere((b) => b.id == 'settings').color;
        } catch (_) {}
      }
    }
  }
  return AppColors.primary;
}
