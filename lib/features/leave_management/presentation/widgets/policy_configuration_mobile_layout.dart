import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_mobile_sheet.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration_mobile_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class PolicyConfigurationMobileLayout extends StatelessWidget {
  const PolicyConfigurationMobileLayout({
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

    return PolicyConfigurationMobileContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyMobileTabHeader(
        title: localizations.policyConfiguration,
        trailing: canCreate
            ? AppMobileButton(
                svgPath: Assets.icons.addBusinessUnitIcon.path,
                onPressed: () => AddPolicyMobileSheet.show(context),
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
