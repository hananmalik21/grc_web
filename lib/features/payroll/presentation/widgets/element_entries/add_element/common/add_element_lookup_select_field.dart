import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/payroll/application/element_entries/providers/add_element_lookups_provider.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_value_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElementLookupSelectField extends ConsumerWidget {
  const AddElementLookupSelectField({
    required this.label,
    required this.typeCode,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final String typeCode;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  AutoDisposeFutureProvider<List<PayLookupValue>> get _provider {
    return switch (typeCode) {
      PayLookupTypeCode.entryType => addElementEntryTypeLookupValuesProvider,
      PayLookupTypeCode.source => addElementSourceLookupValuesProvider,
      PayLookupTypeCode.elementProcessingType => addElementProcessingTypeLookupValuesProvider,
      PayLookupTypeCode.elementClassificationCode => addElementElementClassificationLookupValuesProvider,
      PayLookupTypeCode.contextSegment => addElementContextSegmentLookupValuesProvider,
      PayLookupTypeCode.costAllocationKeyField => addElementCostAllocationKeyFieldLookupValuesProvider,
      PayLookupTypeCode.costingType => addElementCostingTypeLookupValuesProvider,
      _ => addElementEntryTypeLookupValuesProvider,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(_provider);

    return lookupsAsync.when(
      data: (lookups) {
        final codes = lookups.map((item) => item.valueCode).where((code) => code.trim().isNotEmpty).toList();

        return DigifySelectFieldWithLabel<String>(
          label: label,
          isRequired: isRequired,
          value: value,
          items: codes,
          itemLabelBuilder: (code) => lookups.labelForCode(code) ?? code,
          onChanged: onChanged,
        );
      },
      loading: () => DigifySelectFieldWithLabel<String>(
        label: label,
        isRequired: isRequired,
        value: value,
        items: const [],
        itemLabelBuilder: (code) => code,
        onChanged: null,
      ),
      error: (_, _) => DigifySelectFieldWithLabel<String>(
        label: label,
        isRequired: isRequired,
        value: value,
        items: const [],
        itemLabelBuilder: (code) => code,
        onChanged: null,
      ),
    );
  }
}
