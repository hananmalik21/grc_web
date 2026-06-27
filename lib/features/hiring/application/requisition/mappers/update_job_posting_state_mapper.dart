import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/application/requisition/states/update_job_posting_state.dart';
import 'package:grc/features/hiring/presentation/models/job_posting_view_data.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';

class UpdateJobPostingStateMapper {
  UpdateJobPostingStateMapper._();

  static UpdateJobPostingState fromViewData({required JobPostingViewData posting, required String requisitionGuid}) {
    return UpdateJobPostingState(
      postingGuid: posting.postingGuid,
      requisitionGuid: requisitionGuid,
      postingTitle: _unwrap(posting.title),
      postingDescription: _unwrap(posting.description),
      aboutTheRole: posting.aboutTheRole,
      responsibilitiesText: posting.responsibilitiesText,
      qualificationsText: posting.qualificationsText,
      startDate: posting.startDateTime ?? _parseDate(posting.startDate),
      endDate: posting.endDateTime ?? _parseDate(posting.endDate),
      internalSiteFlag: posting.internalSiteFlag,
      externalSiteFlag: posting.externalSiteFlag,
      linkedinFlag: posting.linkedinFlag,
      visibilityCode: posting.visibilityCode,
    );
  }

  static String _unwrap(String value) {
    return RequisitionUiPlaceholder.isPlaceholder(value) ? '' : value;
  }

  static DateTime? _parseDate(String value) {
    if (RequisitionUiPlaceholder.isPlaceholder(value)) return null;
    return DateTimeUtils.parseFlexibleDate(value);
  }
}
