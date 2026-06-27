import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_entitlements_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_content.dart';
import 'package:flutter/material.dart';

class LeaveRequestTabletLayout extends StatelessWidget with LeaveRequestPermissionMixin {
  const LeaveRequestTabletLayout({required this.selectedEnterpriseId, required this.onEnterpriseChanged, super.key});

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LeaveRequestContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: LeaveEntitlementsSection(localizations: localizations),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
