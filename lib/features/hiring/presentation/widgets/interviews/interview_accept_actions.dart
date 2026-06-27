import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/application/interviews/controllers/accept_interview_controller.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAcceptInterviewConfirmationAndAccept(BuildContext context, WidgetRef ref, Interview interview) async {
  final loc = AppLocalizations.of(context)!;

  final confirmed = await AppConfirmationDialog.show(
    context,
    title: loc.accept,
    message: loc.hiringInterviewAcceptConfirmMessage,
    itemName: interview.candidateName,
    confirmLabel: loc.accept,
    cancelLabel: loc.close,
    type: ConfirmationType.success,
    svgPath: Assets.icons.checkIconGreen.path,
  );

  if (confirmed != true || !context.mounted) return;

  await ref.read(acceptInterviewControllerProvider).accept(context, interview: interview);
}
