import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_configuration_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_configuration_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OvertimeConfigurationDesktopLayout extends StatelessWidget with OvertimeConfigurationPermissionMixin {
  const OvertimeConfigurationDesktopLayout({
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
    final localizations = AppLocalizations.of(context)!;

    return OvertimeConfigurationContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyTabHeader(
        title: 'Overtime Configuration',
        description: 'Configure overtime rates, limits, and compliance rules according to Kuwait Labor Law',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: canUpdateOvertimeConfiguration
              ? [
                  AppButton.outline(label: 'Reset Defaults', svgPath: Assets.icons.resetIcon.path, onPressed: () {}),
                  Gap(8.w),
                  AppButton.primary(
                    label: localizations.saveConfiguration,
                    svgPath: Assets.icons.saveConfigIcon.path,
                    isLoading: isLoading,
                    onPressed: onSave,
                  ),
                ]
              : [],
        ),
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
