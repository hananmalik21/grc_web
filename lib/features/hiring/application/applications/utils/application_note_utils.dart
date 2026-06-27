import 'package:grc/core/localization/l10n/app_localizations.dart';

const applicationNoteTypeCodes = <String>['GENERAL', 'INTERVIEW', 'FEEDBACK', 'INTERNAL_REVIEW'];

String applicationNoteTypeLabel(AppLocalizations loc, String code) {
  switch (code.trim().toUpperCase()) {
    case 'GENERAL':
      return loc.hiringApplicationNoteTypeGeneral;
    case 'INTERVIEW':
      return loc.hiringApplicationNoteTypeInterview;
    case 'FEEDBACK':
      return loc.hiringApplicationNoteTypeFeedback;
    case 'INTERNAL_REVIEW':
      return loc.hiringApplicationNoteTypeInternalReview;
    default:
      return code;
  }
}
