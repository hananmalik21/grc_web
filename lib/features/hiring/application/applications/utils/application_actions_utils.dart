import 'package:grc/features/hiring/domain/models/applications/application_pipeline_stage.dart';

class ApplicationActionsVisibility {
  const ApplicationActionsVisibility({
    required this.showMoveStage,
    required this.showScheduleInterview,
    required this.showAddNotes,
    required this.showReject,
  });

  final bool showMoveStage;
  final bool showScheduleInterview;
  final bool showAddNotes;
  final bool showReject;
}

ApplicationActionsVisibility resolveApplicationActionsVisibility({
  required String currentStageCode,
  required bool isRejected,
}) {
  final stage = currentStageCode.trim().toUpperCase();

  if (isRejected || ApplicationPipelineStage.isRejected(stage)) {
    return const ApplicationActionsVisibility(
      showMoveStage: false,
      showScheduleInterview: false,
      showAddNotes: true,
      showReject: false,
    );
  }

  if (stage == ApplicationPipelineStage.hired) {
    return const ApplicationActionsVisibility(
      showMoveStage: false,
      showScheduleInterview: false,
      showAddNotes: true,
      showReject: false,
    );
  }

  return ApplicationActionsVisibility(
    showMoveStage: true,
    showScheduleInterview: stage == ApplicationPipelineStage.interview,
    showAddNotes: true,
    showReject: true,
  );
}
