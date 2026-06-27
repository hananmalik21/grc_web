import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/requisition/states/create_job_posting_state.dart';
import 'package:grc/features/hiring/domain/models/job_postings/create_job_posting_input.dart';

class CreateJobPostingRequestMapper {
  CreateJobPostingRequestMapper._();

  static const String defaultVisibilityCode = 'PUBLIC';

  static CreateJobPostingInput fromState({
    required CreateJobPostingState state,
    required int enterpriseId,
    required String createdBy,
  }) {
    return CreateJobPostingInput(
      enterpriseId: enterpriseId,
      requisitionGuid: state.requisitionGuid,
      postingTitle: state.postingTitle.trim(),
      postingDescription: state.postingDescription.trim(),
      visibilityCode: defaultVisibilityCode,
      startDate: DateTimeUtils.formatYmd(state.startDate!),
      endDate: state.endDate != null ? DateTimeUtils.formatYmd(state.endDate!) : null,
      aboutTheRole: state.aboutTheRole.trim(),
      responsibilities: _parseCommaSeparated(state.responsibilitiesText),
      qualifications: _parseCommaSeparated(state.qualificationsText),
      internalSiteFlag: state.internalSiteFlag,
      externalSiteFlag: state.externalSiteFlag,
      linkedinFlag: state.linkedinFlag,
      createdBy: createdBy,
    );
  }

  static List<String> _parseCommaSeparated(String text) {
    return text.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }
}
