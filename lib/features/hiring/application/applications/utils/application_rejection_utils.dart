import 'package:grc/core/localization/l10n/app_localizations.dart';

const applicationRejectionReasonCodes = <String>[
  'NOT_MATCHING_REQUIREMENTS',
  'OVERQUALIFIED',
  'SALARY_EXPECTATIONS_TOO_HIGH',
  'FAILED_TECHNICAL_ASSESSMENT',
  'POOR_CULTURE_FIT',
  'POSITION_FILLED',
  'CANDIDATE_WITHDREW',
  'OTHER',
];

String applicationRejectionReasonLabel(AppLocalizations loc, String code) {
  switch (code.trim().toUpperCase()) {
    case 'NOT_MATCHING_REQUIREMENTS':
      return loc.hiringApplicationRejectReasonNotMatching;
    case 'OVERQUALIFIED':
      return loc.hiringApplicationRejectReasonOverqualified;
    case 'SALARY_EXPECTATIONS_TOO_HIGH':
      return loc.hiringApplicationRejectReasonSalary;
    case 'FAILED_TECHNICAL_ASSESSMENT':
      return loc.hiringApplicationRejectReasonTechnical;
    case 'POOR_CULTURE_FIT':
      return loc.hiringApplicationRejectReasonCultureFit;
    case 'POSITION_FILLED':
      return loc.hiringApplicationRejectReasonPositionFilled;
    case 'CANDIDATE_WITHDREW':
      return loc.hiringApplicationRejectReasonWithdrew;
    case 'OTHER':
      return loc.hiringApplicationRejectReasonOther;
    default:
      return code;
  }
}
