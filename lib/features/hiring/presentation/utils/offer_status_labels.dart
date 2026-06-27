import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/gen/assets.gen.dart';

String offerStatusDropdownLabel(AppLocalizations loc, String? value) {
  return switch (OfferStatusCode.normalize(value)) {
    '' => loc.allOffers,
    OfferStatusCode.draft => loc.offerStatusDraft,
    OfferStatusCode.approved => loc.offerStatusApproved,
    OfferStatusCode.decline => loc.offerStatusDecline,
    OfferStatusCode.withdraw => loc.offerStatusWithdraw,
    OfferStatusCode.extend => loc.offerStatusExtend,
    _ => loc.allOffers,
  };
}

String offerStatusActionLabel(AppLocalizations loc, String statusCode) {
  return switch (OfferStatusCode.normalize(statusCode)) {
    OfferStatusCode.approved => loc.offerStatusApprove,
    OfferStatusCode.withdraw => loc.offerStatusWithdraw,
    OfferStatusCode.extend => loc.offerStatusExtend,
    _ => offerStatusDropdownLabel(loc, statusCode),
  };
}

String offerStatusDisplayLabel(AppLocalizations loc, String statusCode) {
  final label = offerStatusDropdownLabel(loc, statusCode);
  return label == loc.allOffers ? statusCode : label;
}

String offerStatusCapsuleLabel(AppLocalizations loc, String value) {
  return switch (value) {
    OfferStatusCode.draft => loc.offerStatusDraft,
    OfferStatusCode.approved => loc.offerStatusApproved,
    _ => value,
  };
}

String offerStatusCapsuleIcon(String value) {
  return switch (value) {
    OfferStatusCode.draft => Assets.icons.clockIcon.path,
    OfferStatusCode.approved => Assets.icons.checkIconGreen.path,
    _ => Assets.icons.infoIconGreen.path,
  };
}
