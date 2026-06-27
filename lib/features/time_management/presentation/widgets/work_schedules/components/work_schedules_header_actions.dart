import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WorkSchedulesHeaderActions extends StatelessWidget {
  const WorkSchedulesHeaderActions({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: 'Create Work Schedule',
      svgPath: Assets.icons.addDivisionIcon.path,
      onPressed: onCreatePressed,
    );
  }
}
