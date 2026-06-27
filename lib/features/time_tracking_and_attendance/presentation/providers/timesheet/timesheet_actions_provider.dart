import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimesheetActions {
  static Future<void> approveTimesheet(
    BuildContext context,
    WidgetRef ref,
    Timesheet timesheet,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.approveTimesheetConfirmTitle,
      message: localizations.approveTimesheetConfirmMessage,
      confirmLabel: localizations.approve,
      cancelLabel: localizations.close,
      type: ConfirmationType.success,
      icon: Icons.check_circle_outline_rounded,
    );

    if (confirmed != true) return;

    final notifier = ref.read(timesheetNotifierProvider.notifier);
    final error = await notifier.approveTimesheet(timesheet.guid);

    if (!context.mounted) return;

    if (error == null) {
      ToastService.success(context, 'Timesheet approved', title: 'Success');
    } else {
      ToastService.error(
        context,
        error.replaceFirst('Exception: ', ''),
        title: 'Error',
      );
    }
  }

  static Future<void> rejectTimesheet(
    BuildContext context,
    WidgetRef ref,
    Timesheet timesheet,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    final reason = await AppConfirmationDialog.showWithInput(
      context,
      title: localizations.rejectTimesheetConfirmTitle,
      message: localizations.rejectTimesheetConfirmMessage,
      confirmLabel: localizations.reject,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      icon: Icons.cancel_outlined,
      textFieldLabel: localizations.rejectReason,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return localizations.rejectReasonRequired;
        }
        return null;
      },
    );

    if (!context.mounted || reason == null || reason.trim().isEmpty) return;

    final notifier = ref.read(timesheetNotifierProvider.notifier);
    final error = await notifier.rejectTimesheet(
      timesheet.guid,
      rejectReason: reason.trim(),
    );

    if (!context.mounted) return;

    if (error == null) {
      ToastService.success(context, 'Timesheet rejected', title: 'Success');
    } else {
      ToastService.error(
        context,
        error.replaceFirst('Exception: ', ''),
        title: 'Error',
      );
    }
  }
}
