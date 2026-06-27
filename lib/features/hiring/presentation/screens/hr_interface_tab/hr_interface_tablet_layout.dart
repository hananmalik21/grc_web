import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/hr_interface_tab/hr_interface_content.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_header.dart';
import 'package:flutter/material.dart';

class HrInterfaceTabletLayout extends StatelessWidget {
  const HrInterfaceTabletLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    return HrInterfaceContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const HrInterfaceHeader(),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
