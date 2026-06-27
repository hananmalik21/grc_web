import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_duty_role_dialog/edit_duty_role_dialog_content.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/duty_role_form_mobile_sheet.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';

class EditDutyRoleDialog extends StatelessWidget {
  const EditDutyRoleDialog({super.key, required this.role});

  final DutyRoleItem role;

  static Future<void> show(BuildContext context, {required DutyRoleItem role}) {
    if (context.isMobile) {
      return DutyRoleFormMobileSheet.showEdit(context, role: role);
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditDutyRoleDialog(role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditDutyRoleDialogContent(role: role);
  }
}
