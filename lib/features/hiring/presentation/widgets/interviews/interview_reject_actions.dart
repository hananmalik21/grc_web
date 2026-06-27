import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/application/interviews/controllers/reject_interview_controller.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showRejectInterviewConfirmationAndReject(BuildContext context, WidgetRef ref, Interview interview) async {
  final loc = AppLocalizations.of(context)!;

  final confirmed = await AppConfirmationDialog.show(
    context,
    title: loc.reject,
    message: loc.hiringInterviewRejectConfirmMessage,
    itemName: interview.candidateName,
    confirmLabel: loc.reject,
    cancelLabel: loc.close,
    type: ConfirmationType.danger,
    svgPath: Assets.icons.closeDialogIcon.path,
  );

  if (confirmed != true || !context.mounted) return;

  await ref.read(rejectInterviewControllerProvider).reject(context, interview: interview);
}
