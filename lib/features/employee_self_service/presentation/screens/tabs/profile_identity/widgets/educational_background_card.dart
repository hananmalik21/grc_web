import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_empty_state_box.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EducationalBackgroundCard extends StatelessWidget {
  final VoidCallback onUpdateRecords;

  const EducationalBackgroundCard({super.key, required this.onUpdateRecords});

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      title: 'Educational Background',
      titleIconPath: Assets.icons.employeeSelfService.education.path,
      trailing: AppButton.primary(
        label: 'Update Records',
        svgPath: Assets.icons.editIcon.path,
        onPressed: onUpdateRecords,
      ),
      child: EssEmptyStateBox(
        iconPath: Assets.icons.employeeSelfService.learning.path,
        title: 'No education records found',
        subtitle: 'Keep degrees and certifications up to date',
        primaryActionLabel: 'Update Records',
        onPrimaryAction: onUpdateRecords,
        dashedBorder: true,
        dashedBorderColor: AppColors.cardBorder,
      ),
    );
  }
}
