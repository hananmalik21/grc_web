import 'package:flutter/material.dart';

/// Model representing a login feature card
class LoginFeature {
  final String iconPath;
  final Color iconBackgroundColor;
  final String titleKey;
  final String descriptionKey;

  const LoginFeature({
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.titleKey,
    required this.descriptionKey,
  });
}
