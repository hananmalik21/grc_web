import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/domain/models/system_user.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin UserManagementDeleteMixin on ConsumerWidget {
  bool isUserDeleting(WidgetRef ref, String userGuid) {
    return ref.watch(userManagementProvider.select((state) => state.deletingUserGuids.contains(userGuid)));
  }

  Future<void> confirmAndDeleteUser({
    required BuildContext context,
    required WidgetRef ref,
    required SystemUser user,
  }) async {
    if (isUserDeleting(ref, user.userGuid)) return;
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete User',
      message: 'Are you sure you want to delete this user?',
      itemName: user.name,
    );
    if (confirmed != true) return;

    try {
      await ref.read(userManagementProvider.notifier).deleteUser(userGuid: user.userGuid);
      ToastService.successRoot('User deleted successfully');
    } catch (e) {
      ToastService.errorRoot(e.toString());
    }
  }
}
