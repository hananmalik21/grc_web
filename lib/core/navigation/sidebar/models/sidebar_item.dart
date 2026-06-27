import 'package:flutter/material.dart';

class SidebarItem {
  final String id;
  final IconData? icon;
  final String? svgPath;
  final String labelKey;
  final List<SidebarItem>? children;
  final String? route;
  final String? subtitle;

  const SidebarItem({
    required this.id,
    this.icon,
    this.svgPath,
    required this.labelKey,
    this.children,
    this.route,
    this.subtitle,
  });
}
