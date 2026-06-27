import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/responsive/responsive_helper.dart';
import '../../../../../core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'roles_management_content.dart';

class RolesManagementMobileLayout extends StatelessWidget {
  const RolesManagementMobileLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    return RolesManagementContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const DigifyMobileTabHeader(title: 'Roles Management'),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
