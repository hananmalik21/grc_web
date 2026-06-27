import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionRecLookupSelectField extends ConsumerWidget {
  const CreateRequisitionRecLookupSelectField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedKey,
    required this.lookups,
    required this.onChanged,
    this.isRequired = false,
    this.matchByGuid = false,
    this.fillColor,
  });

  final String label;
  final String hint;
  final String? selectedKey;
  final List<RecLookupValue> lookups;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final bool matchByGuid;
  final Color? fillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    final codes = lookups
        .map((v) => matchByGuid ? v.lookupGuid : v.lookupCode)
        .where((c) => c.trim().isNotEmpty)
        .toList();

    String labelFor(String code) {
      final value = matchByGuid ? lookups.byGuid(code) : lookups.byCode(code);
      return value?.labelForLocale(isRtl: isRtl) ?? code;
    }

    return DigifySelectFieldWithLabel<String>(
      label: label,
      hint: hint,
      isRequired: isRequired,
      value: selectedKey,
      items: codes,
      itemLabelBuilder: labelFor,
      fillColor: fillColor,
      onChanged: onChanged,
    );
  }
}
