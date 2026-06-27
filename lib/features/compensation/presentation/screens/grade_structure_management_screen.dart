import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../dialogs/grade_structure_management/grade_level_dialog.dart';
import '../providers/grade_structure_management/grade_structure_management_enterprise_provider.dart';
import '../widgets/grade_structure_management/component_states.dart';
import '../widgets/grade_structure_management/component_table.dart';

class GradeStructureManagementScreen extends ConsumerWidget {
  const GradeStructureManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(gradeStructureManagementEnterpriseIdProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          children: [
            DigifyTabHeader(
              title: 'Grade Structure Management',
              description: 'Define enterprise compensation tiers, salary ranges, and institutional grade mapping.',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.primary(
                    label: localizations.addGrade,
                    svgPath: Assets.icons.addNewIconFigma.path,
                    onPressed: () => GradeLevelDialog.show(context),
                  ),
                ],
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(gradeStructureManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
            ),
            Gap(24.h),
            const ComponentGradeStructureStats(),
            Gap(24.h),
            const ComponentGradeStructureTable(),
          ],
        ),
      ),
    );
  }
}
