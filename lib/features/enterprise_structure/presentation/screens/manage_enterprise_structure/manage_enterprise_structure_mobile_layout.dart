import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_content.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ManageEnterpriseStructureMobileLayout extends StatelessWidget with ManageEnterpriseStructurePermissionMixin {
  const ManageEnterpriseStructureMobileLayout({
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
    return ManageEnterpriseStructureContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'Manage Enterprise Structure',
        trailing: canCreateStructure
            ? AppMobileButton.primary(
                svgPath: Assets.icons.createNewStructureIcon.path,
                onPressed: onCreateStructurePressed,
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
