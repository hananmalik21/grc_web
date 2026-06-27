import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';

extension RecLookupValueListX on List<RecLookupValue> {
  RecLookupValue? byCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;
    final normalized = code.trim().toUpperCase();
    for (final value in this) {
      if (value.lookupCode.trim().toUpperCase() == normalized) return value;
    }
    return null;
  }

  RecLookupValue? byGuid(String? guid) {
    if (guid == null || guid.trim().isEmpty) return null;
    final normalized = guid.trim();
    for (final value in this) {
      if (value.lookupGuid.trim() == normalized) return value;
    }
    return null;
  }

  String? labelForCode(String? code, {required bool isRtl}) {
    return byCode(code)?.labelForLocale(isRtl: isRtl);
  }

  String? labelForGuid(String? guid, {required bool isRtl}) {
    return byGuid(guid)?.labelForLocale(isRtl: isRtl);
  }

  String? codeForLabel(String? label, {required bool isRtl}) {
    if (label == null || label.trim().isEmpty) return null;
    final normalized = label.trim().toLowerCase();
    for (final value in this) {
      if (value.lookupCode.trim().toLowerCase() == normalized) {
        return value.lookupCode;
      }
      if (value.meaningEn.trim().toLowerCase() == normalized) {
        return value.lookupCode;
      }
      if (value.meaningAr.trim().toLowerCase() == normalized) {
        return value.lookupCode;
      }
      if (value.labelForLocale(isRtl: isRtl).trim().toLowerCase() == normalized) {
        return value.lookupCode;
      }
    }
    return null;
  }
}
