import 'package:grc/core/models/lookup_option.dart';

class LookupLabelResolutionService {
  const LookupLabelResolutionService();

  LookupOption? match(List<LookupOption> options, String? label, {required bool isRtl}) {
    if (label == null || label.trim().isEmpty) return null;
    final trimmed = label.trim();
    for (final option in options) {
      if (option.labelForLocale(isRtl: isRtl) == trimmed) return option;
    }
    return null;
  }

  String? code(List<LookupOption> options, String? label, {required bool isRtl}) {
    return match(options, label, isRtl: isRtl)?.lookupCode;
  }

  String? guid(List<LookupOption> options, String? label, {required bool isRtl}) {
    return match(options, label, isRtl: isRtl)?.lookupGuid;
  }

  String? meaningEn(List<LookupOption> options, String? label, {required bool isRtl}) {
    return match(options, label, isRtl: isRtl)?.meaningEn;
  }

  LookupOption? matchByCode(List<LookupOption> options, String? code) {
    if (code == null || code.trim().isEmpty) return null;
    final normalized = code.trim().toUpperCase();
    for (final option in options) {
      if (option.lookupCode.trim().toUpperCase() == normalized) return option;
    }
    return null;
  }

  LookupOption? matchByGuid(List<LookupOption> options, String? guid) {
    if (guid == null || guid.trim().isEmpty) return null;
    final normalized = guid.trim();
    for (final option in options) {
      if (option.lookupGuid.trim() == normalized) return option;
    }
    return null;
  }

  String? labelForCode(List<LookupOption> options, String? code, {required bool isRtl}) {
    return matchByCode(options, code)?.labelForLocale(isRtl: isRtl);
  }

  String? labelForGuid(List<LookupOption> options, String? guid, {required bool isRtl}) {
    return matchByGuid(options, guid)?.labelForLocale(isRtl: isRtl);
  }
}
