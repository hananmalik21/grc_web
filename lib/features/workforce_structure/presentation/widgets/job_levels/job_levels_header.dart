import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../gen/assets.gen.dart';

class JobLevelsHeader extends StatelessWidget {
  const JobLevelsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localizations.jobLevels,
          style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        AppButton.primary(
          svgPath: Assets.icons.addNewIconFigma.path,
          label: localizations.addJobFamily,
          onPressed: () => JobLevelFormDialog.show(context, onSave: (level) {}),
        ),
      ],
    );
  }
}
