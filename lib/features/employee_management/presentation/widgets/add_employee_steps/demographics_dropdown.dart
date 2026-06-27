import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_type.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemographicsDropdown extends ConsumerWidget {
  const DemographicsDropdown({
    super.key,
    required this.type,
    required this.enterpriseId,
    required this.demographics,
    required this.demographicsNotifier,
  });

  final EmplLookupType type;
  final int enterpriseId;
  final AddEmployeeDemographicsState demographics;
  final AddEmployeeDemographicsNotifier demographicsNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final valuesAsync = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: type.typeCode)),
    );
    final values = valuesAsync.valueOrNull ?? [];
    final isLoadingValues = valuesAsync.isLoading;
    final selectedCode = demographics.getLookupCodeByTypeCode(type.typeCode);
    final selected = _valueByCode(selectedCode, values);

    return DigifySelectFieldWithLabel<EmplLookupValue>(
      label: type.typeName,
      hint: isLoadingValues ? localizations.pleaseWait : 'Select ${type.typeName}',
      items: values,
      itemLabelBuilder: (v) => v.meaningEn,
      value: selected,
      onChanged: isLoadingValues
          ? null
          : (v) => demographicsNotifier.setLookupValueByTypeCode(type.typeCode, v?.lookupCode),
      isRequired: true,
    );
  }

  static EmplLookupValue? _valueByCode(String? code, List<EmplLookupValue> values) {
    if (code == null || code.isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupCode == code);
    } catch (_) {
      return null;
    }
  }
}
