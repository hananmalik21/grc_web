import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class PublicHolidaysHeaderActions extends StatelessWidget {
  const PublicHolidaysHeaderActions({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: 'Create Holiday',
      svgPath: Assets.icons.addDivisionIcon.path,
      onPressed: onCreatePressed,
    );
  }
}
