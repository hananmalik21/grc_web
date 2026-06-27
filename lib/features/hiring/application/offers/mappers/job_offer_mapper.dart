import 'package:grc/features/hiring/domain/models/job_offers/job_offer.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:intl/intl.dart';

Offer toOfferListItem(JobOffer jobOffer) {
  return Offer(
    id: jobOffer.offerNumber,
    offerGuid: jobOffer.offerGuid,
    enterpriseId: jobOffer.enterpriseId,
    candidateName: jobOffer.candidateName,
    candidateInitials: _initialsFromName(jobOffer.candidateName),
    position: jobOffer.positionName.isNotEmpty ? jobOffer.positionName : jobOffer.jobTitle,
    department: jobOffer.departmentName,
    location: jobOffer.location,
    startDate: jobOffer.startDate,
    annualSalary: _formatSalary(jobOffer.annualSalary, jobOffer.currencyCode),
    status: OfferStatusCode.normalize(jobOffer.statusCode),
    level: jobOffer.gradeName,
    type: _formatCodeLabel(jobOffer.employmentTypeCode),
    probationPeriod: jobOffer.probationPeriod,
    expiryDate: jobOffer.expiryDate.isNotEmpty ? jobOffer.expiryDate : null,
  );
}

String _initialsFromName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';

  final names = trimmed.split(RegExp(r'\s+'));
  if (names.length >= 2) {
    return '${names.first[0]}${names[1][0]}'.toUpperCase();
  }

  return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
}

String _formatCodeLabel(String code) {
  final trimmed = code.trim();
  if (trimmed.isEmpty) return trimmed;

  return trimmed
      .toLowerCase()
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _formatSalary(num amount, String currencyCode) {
  final formatted = NumberFormat('#,##0').format(amount);
  final currency = currencyCode.trim();
  if (currency.isEmpty) return formatted;
  return '$currency $formatted';
}
