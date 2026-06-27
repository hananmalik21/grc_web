import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/create_data_role_dialog_content.dart';
import 'package:flutter/material.dart';

class CreateDataRoleDialog extends StatelessWidget {
  const CreateDataRoleDialog({super.key});

  static Future<void> show(BuildContext context, {String title = DataRoleFormConfig.dialogTitle}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: CreateDataRoleDialogContent(title: title),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateDataRoleDialogContent(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreateDataRoleDialogContent();
  }
}
