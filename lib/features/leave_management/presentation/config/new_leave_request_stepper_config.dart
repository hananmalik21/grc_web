import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/gen/assets.gen.dart';

List<StepperStepConfig> newLeaveRequestStepperSteps(AppLocalizations l10n) {
  return [
    StepperStepConfig(assetPath: Assets.icons.leaveManagement.emptyLeave.path, label: l10n.leaveDetails),
    StepperStepConfig(assetPath: Assets.icons.leaveManagement.forfeitReports.path, label: l10n.contactNotes),
    StepperStepConfig(assetPath: Assets.icons.leaveManagement.attachment.path, label: l10n.documentsReview),
  ];
}
