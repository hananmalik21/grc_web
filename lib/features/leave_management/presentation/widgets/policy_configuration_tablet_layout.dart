import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class PolicyConfigurationTabletLayout extends StatelessWidget {
  const PolicyConfigurationTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final canCreate = PermissionService.instance.can(PermKeys.leavePolicyConfigurationCreate);

    return PolicyConfigurationContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: localizations.policyConfiguration,
        description: localizations.policyConfigurationDescription,
        trailing: canCreate
            ? AppButton.primary(
                label: localizations.addNewPolicy,
                svgPath: Assets.icons.addBusinessUnitIcon.path,
                onPressed: () => AddPolicyDialog.show(context),
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
