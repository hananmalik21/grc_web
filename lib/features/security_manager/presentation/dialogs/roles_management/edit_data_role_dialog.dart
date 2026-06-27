import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/create_data_role_dialog_content.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:flutter/material.dart';

class EditDataRoleDialog extends StatelessWidget {
  const EditDataRoleDialog({super.key, required this.role, this.title = 'Edit Data Role'});

  final String title;
  final DataRoleItem role;

  static Future<void> show(BuildContext context, {required DataRoleItem role, String title = 'Edit Data Role'}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: CreateDataRoleDialogContent(title: title, editingRole: role),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateDataRoleDialogContent(title: title, editingRole: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateDataRoleDialogContent(title: title, editingRole: role);
  }
}
