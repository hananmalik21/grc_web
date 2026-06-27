import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';

class OfferStatusCode {
  OfferStatusCode._();

  static const String draft = 'DRAFT';
  static const String approved = 'APPROVED';
  static const String accepted = 'ACCEPTED';
  static const String decline = 'DECLINED';
  static const String withdraw = 'WITHDRAWN';
  static const String extend = 'EXTENDED';

  static const List<String?> filterDropdownValues = [null, draft, approved, decline, withdraw, extend];

  static const List<String> filterCapsuleValues = [draft, approved];

  static const List<String> all = [draft, approved, decline, withdraw, extend];

  static const List<String> actionableStatuses = [approved, withdraw, extend];

  static String normalize(String? statusCode) {
    final value = (statusCode ?? '').trim().toUpperCase();
    return switch (value) {
      'DECLINE' => decline,
      'WITHDRAW' => withdraw,
      'EXTEND' => extend,
      '' => '',
      _ => value,
    };
  }

  static JobOfferStatusAction? actionForStatus(String statusCode) {
    return switch (normalize(statusCode)) {
      approved => JobOfferStatusAction.approve,
      extend => JobOfferStatusAction.extend,
      withdraw => JobOfferStatusAction.withdraw,
      _ => null,
    };
  }

  static bool canChangeStatus(String currentStatus) {
    return normalize(currentStatus) != withdraw;
  }

  static List<String> availableTransitions(String currentStatus) {
    if (!canChangeStatus(currentStatus)) return [];

    final normalized = normalize(currentStatus);
    return actionableStatuses.where((status) {
      return status != normalized && actionForStatus(status) != null;
    }).toList();
  }

  static bool isDestructive(String statusCode) {
    return normalize(statusCode) == withdraw;
  }
}
