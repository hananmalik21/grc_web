import 'package:flutter/material.dart';

class DashboardButton {
  final String id;
  final String icon;
  final String label;
  final Color color;
  final String route;
  final bool isMultiLine;
  final int? badgeCount;
  final String? subtitle;

  DashboardButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.isMultiLine = false,
    this.badgeCount,
    this.subtitle,
  });

  DashboardButton copyWith({String? label, int? badgeCount, String? subtitle}) {
    return DashboardButton(
      id: id,
      icon: icon,
      label: label ?? this.label,
      color: color,
      route: route,
      isMultiLine: isMultiLine,
      badgeCount: badgeCount ?? this.badgeCount,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

class GridSpec {
  final int columns;
  final double spacing;
  final double tileW;
  final double tileH;
  final bool needsLongPress;

  const GridSpec({
    required this.columns,
    required this.spacing,
    required this.tileW,
    required this.tileH,
    required this.needsLongPress,
  });
}
