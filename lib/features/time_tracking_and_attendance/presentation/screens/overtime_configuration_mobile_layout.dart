import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_configuration_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_configuration_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class OvertimeConfigurationMobileLayout extends StatelessWidget with OvertimeConfigurationPermissionMixin {
  const OvertimeConfigurationMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onSave,
    required this.isLoading,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onSave;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OvertimeConfigurationContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'Overtime Configuration',
        trailing: canUpdateOvertimeConfiguration
            ? AppMobileButton.primary(
                svgPath: Assets.icons.saveConfigIcon.path,
                isLoading: isLoading,
                onPressed: onSave,
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
