import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_families_content.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class JobFamiliesMobileLayout extends StatelessWidget with JobFamiliesPermissionMixin {
  const JobFamiliesMobileLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return JobFamiliesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyMobileTabHeader(
        title: WorkforceTab.jobFamilies.label(localizations),
        trailing: canCreateJobFamily
            ? AppMobileButton.primary(
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: () => JobFamilyFormDialog.show(context),
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
