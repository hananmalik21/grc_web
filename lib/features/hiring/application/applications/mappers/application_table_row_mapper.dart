import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';

ApplicationTableRowData toApplicationTableRowData(Application application) {
  return ApplicationTableRowData(
    applicationGuid: application.applicationGuid,
    applicationId: application.applicationNumber,
    candidateName: application.candidateName,
    candidateId: application.candidateId.toString(),
    jobTitle: application.requisitionTitle.isNotEmpty ? application.requisitionTitle : application.postingTitle,
    requisitionId: application.requisitionNumber,
    appliedDate: application.appliedDate ?? DateTime.now(),
    currentStage: _formatCode(application.currentStageCode),
    status: _formatCode(application.statusCode),
    source: _formatCode(application.sourceCode),
  );
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
