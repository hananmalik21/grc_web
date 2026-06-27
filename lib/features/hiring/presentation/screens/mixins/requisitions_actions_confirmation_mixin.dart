import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

mixin RequisitionsActionsConfirmationMixin {
  Future<bool> confirmApprove(BuildContext context, {required String itemName}) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.approve,
      message: 'Are you sure you want to approve this requisition?',
      itemName: itemName,
      confirmLabel: loc.approve,
      cancelLabel: loc.close,
      type: ConfirmationType.success,
      icon: Icons.check_circle_outline_rounded,
    );

    return confirmed == true;
  }

  Future<String?> confirmReject(BuildContext context, {required String itemName}) async {
    final loc = AppLocalizations.of(context)!;
    final reason = await AppConfirmationDialog.showWithInput(
      context,
      title: loc.reject,
      message: 'Are you sure you want to reject this requisition?',
      itemName: itemName,
      confirmLabel: loc.reject,
      cancelLabel: loc.close,
      type: ConfirmationType.danger,
      icon: Icons.cancel_outlined,
      textFieldLabel: loc.rejectReason,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return loc.rejectReasonRequired;
        }
        return null;
      },
    );

    return reason?.trim();
  }

  Future<bool> confirmDeleteDraft(BuildContext context, {required String itemName}) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.delete,
      message: 'Are you sure you want to delete this requisition?',
      itemName: itemName,
      confirmLabel: loc.delete,
      cancelLabel: loc.close,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    return confirmed == true;
  }
}
