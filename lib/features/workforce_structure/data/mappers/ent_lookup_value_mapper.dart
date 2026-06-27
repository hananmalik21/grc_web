import 'package:grc/features/workforce_structure/data/dto/create_ent_lookup_values_bulk_request_dto.dart';
import 'package:grc/features/workforce_structure/domain/models/ent_lookup_value_input.dart';

class EntLookupValueMapper {
  const EntLookupValueMapper._();

  static String gradeCategoryLookupCode(String code) => code.trim().toUpperCase();

  static int? numericSuffixAfterPrefix(String categoryCode, String lookupCode) {
    final prefix = categoryCode.trim().toUpperCase();
    final code = lookupCode.trim().toUpperCase();
    if (!code.startsWith(prefix)) return null;

    final suffix = code.substring(prefix.length);
    if (suffix.isEmpty) return null;

    return int.tryParse(suffix);
  }

  static int nextGradeNumberSequence({
    required String categoryCode,
    required Iterable<String> existingLookupCodes,
    Iterable<String> pendingLookupCodes = const [],
  }) {
    final prefix = categoryCode.trim().toUpperCase();
    var maxSequence = 0;

    for (final code in {...existingLookupCodes, ...pendingLookupCodes}) {
      final sequence = numericSuffixAfterPrefix(prefix, code);
      if (sequence != null && sequence > maxSequence) {
        maxSequence = sequence;
      }
    }

    return maxSequence + 1;
  }

  static String gradeNumberLookupCodeForSequence(String categoryCode, int sequence) {
    return '${categoryCode.trim().toUpperCase()}$sequence';
  }

  static List<BulkEntLookupValueItemDto> toBulkItems(List<EntLookupValueInput> values) {
    final startDate = DateTime.now().toIso8601String().split('T').first;

    return values.asMap().entries.map((entry) {
      final item = entry.value;
      return BulkEntLookupValueItemDto(
        lookupCode: item.lookupCode,
        meaningEn: item.meaningEn,
        meaningAr: item.meaningEn,
        descriptionEn: item.meaningEn,
        displaySequence: entry.key + 1,
        startDate: startDate,
      );
    }).toList();
  }
}
