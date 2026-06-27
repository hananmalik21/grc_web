import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/hiring/domain/models/job_postings/job_posting.dart';
import 'package:grc/features/hiring/presentation/models/job_posting_view_data.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';

class JobPostingViewMapper {
  JobPostingViewMapper._();

  static JobPostingViewData fromDomain(JobPosting posting) {
    final statusCode = posting.statusCode.trim().toUpperCase();

    final parsedStartDate = DateTimeUtils.parseFlexibleDate(posting.startDate);
    final parsedEndDate = DateTimeUtils.parseFlexibleDate(posting.endDate);

    return JobPostingViewData(
      postingGuid: posting.postingGuid,
      statusLabel: _statusLabel(statusCode),
      isPaused: _isPaused(statusCode),
      title: RequisitionUiPlaceholder.text(posting.postingTitle),
      description: RequisitionUiPlaceholder.text(posting.postingDescription),
      startDate: RequisitionUiPlaceholder.text(posting.startDate),
      endDate: RequisitionUiPlaceholder.text(posting.endDate),
      startDateTime: parsedStartDate,
      endDateTime: parsedEndDate,
      visibility: RequisitionUiPlaceholder.text(posting.visibilityCode),
      applicationsCount: posting.applicationCount,
      channels: _channels(posting),
      aboutTheRole: posting.aboutTheRole,
      responsibilitiesText: posting.responsibilities.join(', '),
      qualificationsText: posting.qualifications.join(', '),
      internalSiteFlag: posting.internalSiteFlag,
      externalSiteFlag: posting.externalSiteFlag,
      linkedinFlag: posting.linkedinFlag,
      visibilityCode: posting.visibilityCode,
    );
  }

  static String _statusLabel(String statusCode) {
    if (statusCode.isEmpty) return 'ACTIVE';
    return statusCode;
  }

  static bool _isPaused(String statusCode) {
    final normalized = statusCode.replaceAll(' ', '_');
    return switch (normalized) {
      'PAUSED' || 'ON_HOLD' || 'HOLD' => true,
      _ => false,
    };
  }

  static List<JobPostingChannelViewData> _channels(JobPosting posting) {
    final channels = <JobPostingChannelViewData>[];

    if (posting.isInternalSiteEnabled) {
      channels.add(
        JobPostingChannelViewData(
          type: JobPostingChannelType.internal,
          postedDate: RequisitionUiPlaceholder.text(posting.internalPostedDate ?? posting.startDate),
        ),
      );
    }

    if (posting.isExternalSiteEnabled) {
      channels.add(
        JobPostingChannelViewData(
          type: JobPostingChannelType.external,
          postedDate: RequisitionUiPlaceholder.text(posting.externalPostedDate ?? posting.startDate),
        ),
      );
    }

    if (posting.isLinkedInEnabled) {
      channels.add(
        JobPostingChannelViewData(
          type: JobPostingChannelType.linkedIn,
          postedDate: RequisitionUiPlaceholder.text(posting.linkedinPostedDate ?? posting.startDate),
        ),
      );
    }

    return channels;
  }
}
