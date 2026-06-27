import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HrInterfaceStatCardData {
  const HrInterfaceStatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconPath,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final String iconPath;
  final Color iconColor;
}

class OfferStatCardData {
  final String title;
  final String value;
  final String subtitle;
  final String iconPath;
  final String? trend;

  const OfferStatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconPath,
    this.trend,
  });
}

class HiringConfig {
  HiringConfig._();

  static const List<int> interviewDurationOptions = [15, 30, 45, 60, 90];

  static const List<String> rejectionReasonOptions = [
    'Not qualified for the role',
    'Overqualified',
    'Salary expectations too high',
    'Failed technical assessment',
    'Poor culture fit',
    'Position filled by another candidate',
    'Candidate withdrew',
    'Other',
  ];

  static const List<String> mockApplicationOptions = ['John Doe - Senior Developer', 'Jane Smith - UI Designer'];

  static const List<String> interviewTypeOptions = [
    'Phone Screen',
    'Technical Interview',
    'Culture Fit',
    'Managerial Interview',
    'Final Round',
  ];

  static const List<String> interviewRoundOptions = ['1', '2', '3', '4', 'Final'];

  static const List<String> interviewLocationOptions = ['Video Call', 'In-Person', 'Phone Call'];

  static const List<String> scheduleInterviewRoundCodes = ['1', '2', '3'];

  static const List<String> scheduleInterviewModeCodes = ['ONSITE', 'ONLINE', 'PHONE'];

  static const Map<String, String> scheduleInterviewModeLabels = {
    'ONSITE': 'On-site',
    'ONLINE': 'Online',
    'PHONE': 'Phone',
  };

  static String scheduleInterviewRoundLabel(String round) => 'Round $round';

  static String scheduleInterviewModeLabel(String mode) {
    final normalized = mode.trim().toUpperCase();
    return scheduleInterviewModeLabels[normalized] ?? mode;
  }

  static const List<int> requestAssessmentDurationMinutes = [30, 60, 90, 120, 180];

  static String requestAssessmentDurationLabel(int minutes) => '$minutes minutes';

  static const String defaultUpdateAssessmentStatusCode = 'IN_PROGRESS';

  static const List<String> applicationSourceOptions = [
    'Talent Pool',
    'LinkedIn',
    'Referral',
    'Indeed',
    'Portfolio Site',
    'Recruiter',
    'Manual',
  ];

  static const List<String> applicantStageOptions = ['APPLIED', 'SCREENING', 'SHORTLISTED', 'INTERVIEW', 'OFFER'];

  static const List<String> noticePeriodOptions = ['Immediate', '15 days', '30 days', '60 days', '90 days'];

  static const List<String> educationGradeOptions = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D',
    'F',
    'Pass',
    'Distinction',
    'Merit',
  ];

  static const List<String> currentJobOptions = ['Yes', 'No'];

  static const List<String> feedbackRatingOptions = ['STRONG', 'GOOD', 'AVERAGE', 'BAD', 'VERY_BAD'];

  static const List<String> feedbackRecommendationOptions = [
    'HIRE',
    'SELECTED',
    'NO_HIRE',
    'REJECTED',
    'HOLD',
    'NO_HOLD',
  ];

  static const List<String> departmentOptions = ['Engineering', 'Product', 'Design', 'Marketing', 'Sales', 'HR'];

  static const List<String> gradeLevelOptions = [
    'L1 - Entry Level',
    'L2 - Intermediate',
    'L3 - Senior',
    'L4 - Lead',
    'L5 - Principal',
  ];

  static const List<String> employmentTypeOptions = ['Full-time', 'Part-time', 'Contract', 'Internship'];

  static const List<String> workModeOptions = ['On-site', 'Remote', 'Hybrid'];

  static const List<String> payFrequencyOptions = ['Annual', 'Monthly', 'Weekly', 'Bi-weekly'];

  static const List<String> compensationTypeOptions = ['Annual Salary', 'Monthly Salary', 'Hourly Rate'];

  static const List<String> currencyOptions = ['USD', 'EUR', 'GBP', 'SAR', 'AED', 'KWD'];

  static const List<String> vestingPeriodOptions = ['1 year', '2 years', '3 years', '4 years (standard)', '5 years'];

  static const List<String> educationLevelOptions = [
    'High School',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
  ];

  static const List<String> experienceLevelOptions = [
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5-7 years',
    '7-10 years',
    '10+ years',
  ];

  static const List<String> requirementImportanceOptions = ['None Required', 'Preferred', 'Required'];

  static const List<String> travelRequirementOptions = ['0-10%', '11-25%', '26-50%', '50%+'];

  static const List<String> priorityOptions = ['Low', 'Medium', 'High', 'Critical'];

  static const List<String> backgroundCheckPriorityOptions = ['STANDARD', 'HIGH', 'URGENT'];

  static String backgroundCheckPriorityLabel(String code) {
    switch (code.toUpperCase()) {
      case 'HIGH':
        return 'High';
      case 'URGENT':
        return 'Urgent';
      case 'STANDARD':
      default:
        return 'Standard';
    }
  }

  static final DateTime createRequisitionDatePickerFirstDate = DateTime(1900);
  static final DateTime createRequisitionDatePickerLastDate = DateTime(2100, 12, 31);

  static final DateTime candidateFormDatePickerFirstDate = DateTime(1900);
  static final DateTime candidateFormDatePickerLastDate = DateTime(2100, 12, 31);

  static const List<String?> offerStatusDropdownValues = OfferStatusCode.filterDropdownValues;

  static const List<String> offerStatusCapsuleValues = OfferStatusCode.filterCapsuleValues;

  static List<HrInterfaceStatCardData> buildHrInterfaceStatCards(AppLocalizations loc) {
    return [
      HrInterfaceStatCardData(
        title: loc.hiringHrInterfaceStatAcceptedOffers,
        value: '2',
        subtitle: loc.hiringHrInterfaceStatAcceptedOffersSub,
        iconPath: Assets.icons.checkIconGreen.path,
        iconColor: AppColors.success,
      ),
      HrInterfaceStatCardData(
        title: loc.hiringHrInterfaceStatPendingTransfer,
        value: '2',
        subtitle: loc.hiringHrInterfaceStatPendingTransferSub,
        iconPath: Assets.icons.clockIcon.path,
        iconColor: AppColors.warning,
      ),
      HrInterfaceStatCardData(
        title: loc.hiringHrInterfaceStatTransferred,
        value: '0',
        subtitle: loc.thisMonth,
        iconPath: Assets.icons.employeeListIcon.path,
        iconColor: AppColors.statIconBlue,
      ),
      HrInterfaceStatCardData(
        title: loc.hiringHrInterfaceStatNewHires,
        value: '2',
        subtitle: loc.thisMonth,
        iconPath: Assets.icons.priceUpItem.path,
        iconColor: AppColors.purple,
      ),
    ];
  }

  static List<OfferStatCardData> buildOfferStatCards(AppLocalizations loc) {
    return [
      OfferStatCardData(
        title: loc.totalOffers,
        value: '3',
        subtitle: '15% ${loc.thisMonth}',
        iconPath: Assets.icons.hiring.offers.path,
        trend: '15%',
      ),
      OfferStatCardData(
        title: loc.pendingApproval,
        value: '0',
        subtitle: loc.awaitingReview,
        iconPath: Assets.icons.clockIcon.path,
      ),
      OfferStatCardData(
        title: loc.sentToCandidates,
        value: '1',
        subtitle: loc.awaitingResponse,
        iconPath: Assets.icons.submitted.path,
      ),
      OfferStatCardData(
        title: loc.accepted,
        value: '2',
        subtitle: loc.readyToOnboard,
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      OfferStatCardData(
        title: loc.avgOfferValue,
        value: '\$135K',
        subtitle: loc.annualSalary,
        iconPath: Assets.icons.websiteIcon.path,
      ),
    ];
  }

  static List<Offer> getMockOffers() {
    return [
      const Offer(
        id: 'OFF-2026-001',
        candidateName: 'Alex Martinez',
        candidateInitials: 'AM',
        position: 'Senior Software Engineer',
        department: 'Engineering',
        location: 'San Francisco, CA',
        startDate: '2026-06-01',
        annualSalary: '\$165,000',
        status: 'ACCEPTED',
        level: 'L5',
        type: 'Full-time',
        probationPeriod: '3 months',
        signedDate: '2026-06-01',
      ),
      const Offer(
        id: 'OFF-2026-002',
        candidateName: 'Jamie Thompson',
        candidateInitials: 'JT',
        position: 'Product Manager',
        department: 'Product',
        location: 'New York, NY',
        startDate: '2026-07-01',
        annualSalary: '\$135,000',
        status: 'ACCEPTED',
        level: 'L4',
        type: 'Full-time',
        probationPeriod: '3 months',
        signedDate: '2026-07-01',
      ),
      const Offer(
        id: 'OFF-2026-003',
        candidateName: 'Jordan Lee',
        candidateInitials: 'JL',
        position: 'UX Designer',
        department: 'Design',
        location: 'Austin, TX',
        startDate: '2026-06-15',
        annualSalary: '\$105,000',
        status: 'SENT',
        level: 'L3',
        type: 'Full-time',
        probationPeriod: '3 months',
        expiryDate: '2026-05-30',
      ),
    ];
  }

  static List<CandidateCommunicationData> buildCandidateCommunications(String candidateName) {
    return [
      CandidateCommunicationData(
        title: 'Interview Schedule Confirmation',
        type: 'Email',
        direction: 'Outbound',
        date: '2026-04-24',
        time: '10:30 AM',
        description: 'Confirmed interview schedule for April 26',
        detail: 'To: $candidateName',
        status: 'Sent',
      ),
      CandidateCommunicationData(
        title: 'Initial Screening Call',
        type: 'Phone',
        direction: 'Inbound',
        date: '2026-04-23',
        time: '02:15 PM',
        description: '30-minute screening call. Strong candidate. Ready to proceed.',
        detail: 'From: $candidateName',
        status: 'Completed',
      ),
      CandidateCommunicationData(
        title: 'Application Submission',
        type: 'Email',
        direction: 'Inbound',
        date: '2026-04-18',
        time: '09:00 AM',
        description: 'Candidate applied for Senior Software Engineer position',
        detail: 'From: $candidateName',
        status: 'Received',
      ),
    ];
  }

  static List<CandidateNote> buildCandidateNotes(String candidateId, String candidateName) {
    if (candidateId == '1') {
      return [
        const CandidateNote(
          id: 'figma-note-1',
          creator: 'Mike Johnson',
          scope: 'Internal',
          timestamp: '2026-04-23 03:00 PM',
          content: 'Great cultural fit. Strong technical skills. Recommended to move forward with on-site interview.',
          tags: ['Screening', 'Positive'],
          isPrivate: true,
        ),
        const CandidateNote(
          id: 'figma-note-2',
          creator: 'Sarah Chen',
          scope: 'Hiring Team',
          timestamp: '2026-04-20 11:00 AM',
          content: 'Resume shows impressive track record. Worth prioritizing for this role.',
          tags: ['Resume Review'],
          isPrivate: false,
        ),
      ];
    }

    return [
      CandidateNote(
        id: 'figma-note-default',
        creator: 'Mike Johnson',
        scope: 'Internal',
        timestamp: '2026-04-23 03:00 PM',
        content:
            'Candidate has outstanding experience in building clean products. Looks very aligned with the job description for $candidateName.',
        tags: ['Screening', 'Positive'],
        isPrivate: true,
      ),
    ];
  }
}
