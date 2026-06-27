import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ScheduleAssignmentsHeaderActions extends StatelessWidget {
  const ScheduleAssignmentsHeaderActions({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: 'Assign Schedule',
      svgPath: Assets.icons.addDivisionIcon.path,
      onPressed: onCreatePressed,
    );
  }
}
