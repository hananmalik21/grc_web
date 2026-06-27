import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_levels_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class JobLevelsMobileLayout extends StatelessWidget with JobLevelsPermissionMixin {
  const JobLevelsMobileLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return JobLevelsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyMobileTabHeader(
        title: WorkforceTab.jobLevels.label(localizations),
        trailing: canCreateJobLevel
            ? AppMobileButton.primary(
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: () => JobLevelFormDialog.show(context),
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
