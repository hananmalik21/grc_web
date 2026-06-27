import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ManageSalaryStructureHeaderActions extends StatelessWidget {
  const ManageSalaryStructureHeaderActions({
    required this.onCreatePressed,
    super.key,
  });

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: 'Create New Structure',
      svgPath: Assets.icons.addNewIconFigma.path,
      onPressed: onCreatePressed,
    );
  }
}
