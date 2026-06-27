import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_content.dart';
import 'package:flutter/material.dart';

class ManageComponentValuesMobileLayout extends StatelessWidget {
  const ManageComponentValuesMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.child,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ManageComponentValuesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const DigifyMobileTabHeader(title: 'Manage Component Values'),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      child: child,
    );
  }
}
