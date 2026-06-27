import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/components_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'components_content.dart';

class ComponentsMobileLayout extends StatelessWidget with ComponentsPermissionMixin {
  const ComponentsMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreateComponentPressed,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final Future<void> Function() onCreateComponentPressed;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return ComponentsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'Compensation Components',
        trailing: canCreateComponent
            ? AppMobileButton.primary(
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: () => onCreateComponentPressed(),
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
