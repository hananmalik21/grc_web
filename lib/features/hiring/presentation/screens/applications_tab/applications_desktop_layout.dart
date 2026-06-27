import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_content.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_header.dart';
import 'package:flutter/material.dart';

class ApplicationsDesktopLayout extends StatelessWidget {
  const ApplicationsDesktopLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    return ApplicationsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const ApplicationsHeader(),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
