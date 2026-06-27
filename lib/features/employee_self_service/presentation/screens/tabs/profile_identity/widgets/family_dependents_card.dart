import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_empty_state_box.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class FamilyDependentsCard extends StatelessWidget {
  final VoidCallback onAddOrUpdate;
  final VoidCallback onRegisterDependents;

  const FamilyDependentsCard({super.key, required this.onAddOrUpdate, required this.onRegisterDependents});

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      title: 'Family & Dependents',
      titleIconPath: Assets.icons.employeeListIcon.path,
      trailing: AppButton.primary(label: 'Add / Update Family', icon: Icons.add, onPressed: onAddOrUpdate),
      child: EssEmptyStateBox(
        iconPath: Assets.icons.employeeListIcon.path,
        title: 'No family members registered',
        subtitle: 'Register dependents for medical insurance and visa purposes',
        primaryActionLabel: 'Register Dependents',
        onPrimaryAction: onRegisterDependents,
        dashedBorder: true,
        dashedBorderColor: AppColors.cardBorder,
      ),
    );
  }
}
