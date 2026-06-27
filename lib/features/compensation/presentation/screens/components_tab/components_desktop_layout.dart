import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_header.dart';
import 'package:flutter/material.dart';

import 'components_content.dart';

class ComponentsDesktopLayout extends StatelessWidget {
  const ComponentsDesktopLayout({
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
      header: ComponentsHeader(onCreateComponentPressed: onCreateComponentPressed),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
