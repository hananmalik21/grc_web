import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/requisition/mappers/create_job_posting_request_mapper.dart';
import 'package:grc/features/hiring/application/requisition/states/update_job_posting_state.dart';
import 'package:grc/features/hiring/domain/models/job_postings/update_job_posting_input.dart';

class UpdateJobPostingRequestMapper {
  UpdateJobPostingRequestMapper._();

  static UpdateJobPostingInput fromState({
    required UpdateJobPostingState state,
    required int enterpriseId,
    required String lastUpdatedBy,
  }) {
    return UpdateJobPostingInput(
      postingGuid: state.postingGuid,
      enterpriseId: enterpriseId,
      postingTitle: state.postingTitle.trim(),
      postingDescription: state.postingDescription.trim(),
      visibilityCode: state.visibilityCode.trim().isEmpty
          ? CreateJobPostingRequestMapper.defaultVisibilityCode
          : state.visibilityCode.trim(),
      startDate: DateTimeUtils.formatYmd(state.startDate!),
      endDate: state.endDate != null ? DateTimeUtils.formatYmd(state.endDate!) : null,
      aboutTheRole: state.aboutTheRole.trim(),
      responsibilities: _parseCommaSeparated(state.responsibilitiesText),
      qualifications: _parseCommaSeparated(state.qualificationsText),
      internalSiteFlag: state.internalSiteFlag,
      externalSiteFlag: state.externalSiteFlag,
      linkedinFlag: state.linkedinFlag,
      lastUpdatedBy: lastUpdatedBy,
    );
  }

  static List<String> _parseCommaSeparated(String text) {
    return text.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }
}
