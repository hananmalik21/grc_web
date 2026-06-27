import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/create_grade_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class GradeStructureHeader extends StatelessWidget {
  const GradeStructureHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(localizations.gradeStructure, style: context.textTheme.titleMedium),
        AppButton.primary(
          svgPath: Assets.icons.addNewIconFigma.path,
          label: localizations.addGrade,
          onPressed: () => CreateGradeDialog.show(context),
        ),
      ],
    );
  }
}
