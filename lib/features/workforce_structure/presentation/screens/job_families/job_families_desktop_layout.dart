import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_header_actions.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_families_content.dart';
import 'package:flutter/material.dart';

class JobFamiliesDesktopLayout extends StatelessWidget with JobFamiliesPermissionMixin {
  const JobFamiliesDesktopLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return JobFamiliesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: WorkforceTab.jobFamilies.label(localizations),
        trailing: WorkforceHeaderActions.getTrailingAction(context, WorkforceTab.jobFamilies),
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
