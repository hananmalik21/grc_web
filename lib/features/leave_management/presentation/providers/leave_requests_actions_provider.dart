import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveRequestsApproveLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});
final leaveRequestsRejectLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});
final leaveRequestsDeleteLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});

class LeaveRequestsActions {
  static Future<void> approveLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.approvePendingRequests,
      message: 'Are you sure you want to approve this leave request?',
      confirmLabel: localizations.approve,
      cancelLabel: localizations.close,
      type: ConfirmationType.success,
      icon: Icons.check_circle_outline_rounded,
    );

    if (confirmed != true) return;

    try {
      final notifier = ref.read(leaveRequestsNotifierProvider.notifier);
      await notifier.approveLeaveRequest(request.guid);

      if (context.mounted) {
        ToastService.success(context, 'Leave request approved successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  static Future<void> rejectLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.rejected,
      message: 'Are you sure you want to reject this leave request?',
      confirmLabel: localizations.reject,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      icon: Icons.cancel_outlined,
    );

    if (confirmed != true) return;

    try {
      final notifier = ref.read(leaveRequestsNotifierProvider.notifier);
      await notifier.rejectLeaveRequest(request.guid);

      if (context.mounted) {
        ToastService.success(context, 'Leave request rejected successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  static Future<void> deleteLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.delete,
      message: 'Are you sure you want to delete this draft leave request?',
      confirmLabel: localizations.delete,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      icon: Icons.delete_outline,
    );

    if (confirmed != true) return;

    ref.read(leaveRequestsDeleteLoadingProvider.notifier).state = {
      ...ref.read(leaveRequestsDeleteLoadingProvider),
      request.guid,
    };

    try {
      final notifier = ref.read(leaveRequestsNotifierProvider.notifier);
      await notifier.deleteLeaveRequest(request.guid);

      if (context.mounted) {
        ToastService.success(context, 'Draft leave request deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      final loadingSet = {...ref.read(leaveRequestsDeleteLoadingProvider)};
      loadingSet.remove(request.guid);
      ref.read(leaveRequestsDeleteLoadingProvider.notifier).state = loadingSet;
    }
  }

  static Future<void> updateLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final notifier = ref.read(newLeaveRequestProvider.notifier);
    final repository = ref.read(leaveRequestsRepositoryProvider);

    notifier.setLoadingDraft(true);

    if (context.mounted) {
      NewLeaveRequestDialog.show(context);
    }

    try {
      final tenantId = ref.read(leaveManagementEnterpriseIdProvider);
      final response = await repository.getLeaveRequestById(request.guid, tenantId: tenantId);
      await notifier.loadDraftData(response, originalRequest: request);
      notifier.setLoadingDraft(false);
    } catch (e) {
      notifier.setLoadingDraft(false);
      if (context.mounted) {
        Navigator.of(context).maybePop();
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }
}
