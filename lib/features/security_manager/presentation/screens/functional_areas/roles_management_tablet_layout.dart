import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/responsive/responsive_helper.dart';
import '../../../../../core/widgets/common/enterprise_selector_widget.dart';
import 'roles_management_content.dart';

class RolesManagementTabletLayout extends StatelessWidget {
  const RolesManagementTabletLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    return RolesManagementContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const DigifyTabHeader(
        title: 'Roles Management',
        description: 'Manage all role types and access permissions',
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
