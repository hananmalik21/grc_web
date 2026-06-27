import 'package:grc/features/hiring/domain/configs/hiring_config.dart';

abstract final class ScheduleInterviewModeRules {
  ScheduleInterviewModeRules._();

  static String? normalize(String? code) {
    final trimmed = code?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.toUpperCase();
  }

  static bool isValid(String? code) {
    final mode = normalize(code);
    return mode != null && HiringConfig.scheduleInterviewModeCodes.contains(mode);
  }

  static bool requiresMeetingLink(String? code) => normalize(code) == 'ONLINE';
}
