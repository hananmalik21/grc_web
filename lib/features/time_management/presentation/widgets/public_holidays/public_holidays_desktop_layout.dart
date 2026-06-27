import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/public_holidays_header_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_content.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_tab_config.dart';
import 'package:flutter/material.dart';

class PublicHolidaysDesktopLayout extends StatelessWidget with PublicHolidaysPermissionMixin {
  const PublicHolidaysDesktopLayout({
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
    return PublicHolidaysContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: PublicHolidaysTabConfig.headerTitle,
        description: PublicHolidaysTabConfig.headerDescription,
        trailing: canCreatePublicHoliday ? PublicHolidaysHeaderActions(onCreatePressed: onCreatePressed) : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      enterpriseId: selectedEnterpriseId,
    );
  }
}
