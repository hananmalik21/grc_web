import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LeaveEntitlementsSection extends StatelessWidget with LeaveRequestPermissionMixin {
  final AppLocalizations localizations;

  const LeaveEntitlementsSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: localizations.leaveRequests,
      description: localizations.manageEmployeeLeaveRequests,
      trailing: canCreateLeaveRequest
          ? AppButton.primary(
              label: localizations.newLeaveRequest,
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: () => NewLeaveRequestDialog.show(context),
            )
          : null,
    );
  }
}
