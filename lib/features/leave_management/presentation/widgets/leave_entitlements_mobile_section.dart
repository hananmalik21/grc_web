import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_form_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LeaveEntitlementsMobileSection extends StatelessWidget with LeaveRequestPermissionMixin {
  final AppLocalizations localizations;

  const LeaveEntitlementsMobileSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return DigifyMobileTabHeader(
      title: localizations.leaveRequests,
      trailing: canCreateLeaveRequest
          ? AppMobileButton.primary(
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () => NewLeaveRequestMobileSheet.show(context),
            )
          : null,
    );
  }
}
