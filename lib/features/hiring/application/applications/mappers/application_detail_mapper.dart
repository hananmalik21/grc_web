import 'package:grc/features/hiring/domain/models/applications/application_detail.dart';
import 'package:grc/features/hiring/domain/models/applications/application_pipeline_stage.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:intl/intl.dart';

ApplicationDetailData toApplicationDetailData(ApplicationDetail detail) {
  final applied = detail.appliedDate;
  final daysInPipeline = applied == null ? 0 : DateTime.now().difference(applied).inDays.clamp(0, 9999);

  return ApplicationDetailData(
    applicationGuid: detail.applicationGuid,
    applicationNumber: detail.applicationNumber,
    candidateName: detail.candidate.candidateName,
    candidateGuid: detail.candidate.candidateGuid,
    candidateEmail: detail.candidate.email,
    candidatePhone: detail.candidate.phone,
    candidateTitle: detail.candidate.currentTitle,
    candidateEmployer: detail.candidate.currentEmployer,
    candidateLocation: detail.candidate.currentLocation,
    yearsExperience: detail.candidate.yearsExperience,
    postingTitle: detail.posting.postingTitle,
    postingGuid: detail.posting.postingGuid,
    requisitionTitle: detail.requisition.requisitionTitle,
    requisitionNumber: detail.requisition.requisitionNumber,
    requisitionGuid: detail.requisition.requisitionGuid,
    currentStage: _formatCode(detail.currentStageCode),
    currentStageCode: detail.currentStageCode,
    effectivePipelineStageCode: effectivePipelineStageCode(detail),
    status: _formatCode(detail.statusCode),
    statusCode: detail.statusCode,
    source: _formatCode(detail.sourceCode),
    appliedDate: applied,
    isRejected: detail.isRejected,
    hasResume: detail.hasResume,
    resumeFileName: detail.resumeFileName,
    resumeUrl: detail.resumeUrl,
    daysInPipeline: daysInPipeline,
    stageHistory: detail.stageHistory.map(_toTimelineEntry).toList(),
    notesCount: detail.notes.length,
    rejectionComments: detail.rejectionComments,
  );
}

ApplicationTimelineEntry _toTimelineEntry(ApplicationStageHistory history) {
  final toLabel = _formatCode(history.toStageCode);
  final title = history.fromStageCode == null
      ? 'Moved to $toLabel'
      : 'Moved from ${_formatCode(history.fromStageCode!)} to $toLabel';

  return ApplicationTimelineEntry(
    title: title,
    dateLabel: _formatTimelineDate(history.creationDate),
    comments: history.comments,
  );
}

String _formatTimelineDate(DateTime? date) {
  if (date == null) return '—';
  return DateFormat.yMMMd().add_jm().format(date);
}

String _formatCode(String code) {
  if (code.trim().isEmpty) return code;
  return code
      .trim()
      .toLowerCase()
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

/// Last active pipeline stage when application is rejected.
String effectivePipelineStageCode(ApplicationDetail detail) {
  if (!detail.isRejected) {
    return detail.currentStageCode;
  }

  final rejectedEntry = detail.stageHistory.where((h) => ApplicationPipelineStage.isRejected(h.toStageCode)).toList();
  if (rejectedEntry.isNotEmpty) {
    final from = rejectedEntry.last.fromStageCode;
    if (from != null && from.isNotEmpty) {
      return from;
    }
  }

  for (final history in detail.stageHistory.reversed) {
    final from = history.fromStageCode;
    if (from != null && from.isNotEmpty && !ApplicationPipelineStage.isRejected(from)) {
      return from;
    }
  }

  return ApplicationPipelineStage.applied;
}
