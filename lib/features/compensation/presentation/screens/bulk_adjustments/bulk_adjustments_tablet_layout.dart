import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_content.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_adjustments_header_actions.dart';
import 'package:flutter/material.dart';

class BulkAdjustmentsTabletLayout extends StatelessWidget with BulkAdjustmentsPermissionMixin {
  const BulkAdjustmentsTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BulkAdjustmentsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: localizations.bulkCompensationAdjustmentsTitle,
        description: localizations.bulkCompensationAdjustmentsDescription,
        trailing: canCreateBulkAdjustment ? BulkAdjustmentsHeaderActions(onCreatePressed: onCreatePressed) : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
