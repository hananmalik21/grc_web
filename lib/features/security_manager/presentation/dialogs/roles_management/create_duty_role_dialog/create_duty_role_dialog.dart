import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/create_duty_role_dialog_content.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/duty_role_form_mobile_sheet.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';

class CreateDutyRoleDialog extends StatelessWidget {
  const CreateDutyRoleDialog({super.key});

  static Future<void> show(BuildContext context) {
    if (context.isMobile) {
      return DutyRoleFormMobileSheet.showCreate(context);
    }
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => const CreateDutyRoleDialog());
  }

  @override
  Widget build(BuildContext context) {
    return const CreateDutyRoleDialogContent();
  }
}
