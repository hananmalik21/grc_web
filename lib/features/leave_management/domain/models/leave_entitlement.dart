import 'package:flutter/foundation.dart';

/// Domain model representing a Kuwait Labor Law leave entitlement
@immutable
class LeaveEntitlement {
  final String id;
  final String titleKey;
  final String entitlementKey;
  final String backgroundColorKey;
  final String titleColorKey;
  final String subtitleColorKey;

  const LeaveEntitlement({
    required this.id,
    required this.titleKey,
    required this.entitlementKey,
    required this.backgroundColorKey,
    required this.titleColorKey,
    required this.subtitleColorKey,
  });
}
