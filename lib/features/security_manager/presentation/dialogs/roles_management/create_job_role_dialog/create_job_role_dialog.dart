import 'package:grc/features/security_manager/data/config/roles_management/job_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/create_job_role_dialog_content.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:flutter/material.dart';

class CreateJobRoleDialog extends StatelessWidget {
  const CreateJobRoleDialog({super.key});

  static Future<void> show(BuildContext context, {String title = JobRoleFormConfig.dialogTitle}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: CreateJobRoleDialogContent(title: title),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateJobRoleDialogContent(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreateJobRoleDialogContent();
  }
}

class EditJobRoleDialog extends StatelessWidget {
  const EditJobRoleDialog({super.key, required this.role, this.title = 'Edit Job Role'});

  final String title;
  final JobRoleItem role;

  static Future<void> show(BuildContext context, {required JobRoleItem role, String title = 'Edit Job Role'}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: CreateJobRoleDialogContent(title: title, editingRole: role),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateJobRoleDialogContent(title: title, editingRole: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateJobRoleDialogContent(title: title, editingRole: role);
  }
}
