import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_content.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ManageEnterpriseStructureTabletLayout extends StatelessWidget with ManageEnterpriseStructurePermissionMixin {
  const ManageEnterpriseStructureTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreateStructurePressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final Future<void> Function() onCreateStructurePressed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ManageEnterpriseStructureContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyTabHeader(
        title: localizations.manageEnterpriseStructure,
        description: localizations.manageDifferentConfigurations,
        trailing: canCreateStructure
            ? AppButton.primary(
                label: localizations.createNewStructure,
                svgPath: Assets.icons.createNewStructureIcon.path,
                onPressed: onCreateStructurePressed,
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
