import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AdjustmentsHeaderActions extends StatelessWidget {
  const AdjustmentsHeaderActions({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: 'Create Adjustment',
      svgPath: Assets.icons.addDivisionIcon.path,
      onPressed: onCreatePressed,
    );
  }
}
