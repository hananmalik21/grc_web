import 'package:grc/core/localization/l10n/app_localizations.dart';

const interviewFeedbackSkillRatingCodes = <String>['STRONG', 'GOOD', 'AVERAGE', 'BAD', 'VERY_BAD'];

const interviewFeedbackRecommendationCodes = <String>['HIRE', 'SELECTED', 'NO_HIRE', 'REJECTED', 'HOLD', 'NO_HOLD'];

String interviewFeedbackSkillRatingLabel(AppLocalizations loc, String code) {
  switch (code.trim().toUpperCase()) {
    case 'STRONG':
      return loc.interviewFeedbackSkillStrong;
    case 'GOOD':
      return loc.interviewFeedbackSkillGood;
    case 'AVERAGE':
      return loc.interviewFeedbackSkillAverage;
    case 'BAD':
      return loc.interviewFeedbackSkillBad;
    case 'VERY_BAD':
      return loc.interviewFeedbackSkillVeryBad;
    default:
      return code;
  }
}

String interviewFeedbackRecommendationLabel(AppLocalizations loc, String code) {
  switch (code.trim().toUpperCase()) {
    case 'HIRE':
      return loc.interviewFeedbackRecHire;
    case 'SELECTED':
      return loc.interviewFeedbackRecSelected;
    case 'NO_HIRE':
      return loc.interviewFeedbackRecNoHire;
    case 'REJECTED':
      return loc.interviewFeedbackRecRejected;
    case 'HOLD':
      return loc.interviewFeedbackRecHold;
    case 'NO_HOLD':
      return loc.interviewFeedbackRecNoHold;
    default:
      return code;
  }
}
