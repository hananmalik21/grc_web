import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';

class RecLookupValue {
  const RecLookupValue({
    required this.lookupGuid,
    required this.lookupId,
    required this.lookupType,
    required this.lookupCode,
    required this.meaningEn,
    required this.meaningAr,
    this.displaySequence = 0,
    this.descriptionEn,
    this.descriptionAr,
    this.isEnabled = 'Y',
  });

  final String lookupGuid;
  final int lookupId;
  final String lookupType;
  final String lookupCode;
  final String meaningEn;
  final String meaningAr;
  final int displaySequence;
  final String? descriptionEn;
  final String? descriptionAr;
  final String isEnabled;

  factory RecLookupValue.fromWorkModeRow({required String workModeCode, required String workModeLabel}) {
    return RecLookupValue(
      lookupGuid: '',
      lookupId: 0,
      lookupType: RecLookupTypeCodes.workMode,
      lookupCode: workModeCode,
      meaningEn: workModeLabel,
      meaningAr: workModeLabel,
    );
  }

  String labelForLocale({required bool isRtl}) => isRtl ? meaningAr : meaningEn;
}
