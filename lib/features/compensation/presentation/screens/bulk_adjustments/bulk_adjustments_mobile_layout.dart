import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_content.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class BulkAdjustmentsMobileLayout extends StatelessWidget with BulkAdjustmentsPermissionMixin {
  const BulkAdjustmentsMobileLayout({
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
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyMobileTabHeader(
            title: localizations.bulkCompensationAdjustmentsTitle,
            trailing: canCreateBulkAdjustment
                ? AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onCreatePressed)
                : null,
          ),
        ],
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
