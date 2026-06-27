import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/domain/models/applications/application_pipeline_stage.dart';

enum PipelineStepStatus { completed, current, pending }

class ApplicationPipelineStepView {
  const ApplicationPipelineStepView({required this.stageCode, required this.label, required this.status});

  final String stageCode;
  final String label;
  final PipelineStepStatus status;
}

List<ApplicationPipelineStepView> buildApplicationPipelineSteps({
  required AppLocalizations loc,
  required String effectiveStageCode,
  required bool isRejected,
}) {
  final currentIndex = ApplicationPipelineStage.indexOf(effectiveStageCode);
  final resolvedIndex = currentIndex < 0 ? 0 : currentIndex;

  return ApplicationPipelineStage.ordered.map((code) {
    final stepIndex = ApplicationPipelineStage.indexOf(code);
    return ApplicationPipelineStepView(
      stageCode: code,
      label: _labelForStage(loc, code),
      status: _statusForStep(stepIndex: stepIndex, currentIndex: resolvedIndex, isRejected: isRejected),
    );
  }).toList();
}

PipelineStepStatus _statusForStep({required int stepIndex, required int currentIndex, required bool isRejected}) {
  if (isRejected) {
    if (stepIndex < currentIndex) return PipelineStepStatus.completed;
    if (stepIndex == currentIndex) return PipelineStepStatus.current;
    return PipelineStepStatus.pending;
  }

  if (stepIndex < currentIndex) return PipelineStepStatus.completed;
  if (stepIndex == currentIndex) return PipelineStepStatus.current;
  return PipelineStepStatus.pending;
}

List<String> selectablePipelineStageCodes(String currentStageCode) {
  final current = currentStageCode.trim().toUpperCase();
  return ApplicationPipelineStage.ordered.where((code) => code != current).toList();
}

String pipelineStageLabel(AppLocalizations loc, String code) {
  return _labelForStage(loc, code);
}

String _labelForStage(AppLocalizations loc, String code) {
  return switch (code.toUpperCase()) {
    ApplicationPipelineStage.applied => loc.hiringPipelineApplied,
    ApplicationPipelineStage.screening => loc.hiringPipelineScreening,
    ApplicationPipelineStage.shortlisted => loc.hiringPipelineShortlisted,
    ApplicationPipelineStage.interview => loc.hiringPipelineInterview,
    ApplicationPipelineStage.offer => loc.hiringPipelineOffer,
    ApplicationPipelineStage.selected => loc.hiringPipelineSelected,
    ApplicationPipelineStage.hired => loc.hiringPipelineHired,
    ApplicationPipelineStage.rejected => loc.hiringPipelineRejected,
    _ => code,
  };
}
