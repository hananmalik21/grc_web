import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_function_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_function_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/function_role_form_mobile_sheet.dart';
import 'package:flutter/material.dart';

abstract final class FunctionRoleFormDialog {
  static Future<void> showCreate(BuildContext context) {
    if (context.isMobile) {
      return FunctionRoleFormMobileSheet.showCreate(context);
    }
    return CreateFunctionRoleDialog.show(context);
  }

  static Future<void> showEdit(BuildContext context, {required FunctionRoleItem role}) {
    if (context.isMobile) {
      return FunctionRoleFormMobileSheet.showEdit(context, role: role);
    }
    return EditFunctionRoleDialog.show(context, role: role);
  }
}
