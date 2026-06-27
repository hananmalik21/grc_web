import 'package:grc/features/payroll/application/element_entries/config/add_element_form_config.dart';
import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:grc/features/payroll/data/dto/create_element_entry_request_dto.dart';
import 'package:intl/intl.dart';

class AddElementFormRequestMapper {
  AddElementFormRequestMapper._();

  static const String defaultContextValue = 'KUWAIT';
  static const String defaultComments = 'Created manually';

  static const Map<String, String> _creatorTypeCodeMap = {
    'User': 'USER',
    'System': 'SYSTEM',
    'Administrator': 'ADMINISTRATOR',
    'HR Admin': 'HR_ADMIN',
    'Payroll Admin': 'PAYROLL_ADMIN',
    'Interface': 'INTERFACE',
  };

  static CreateElementEntryRequestDto toRequestDto({
    required AddElementFormState state,
    required int enterpriseId,
    required int employeeId,
    required String approvalStatusCode,
  }) {
    final component = state.elementComponent!;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return CreateElementEntryRequestDto(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      payrollId: null,
      componentId: component.componentId,
      elementClassificationCode: state.elementClassification ?? '',
      effectiveAsOfDate: dateFormat.format(state.effectiveAsOfDate!),
      effectiveStartDate: dateFormat.format(state.effectiveStartDate!),
      effectiveEndDate: state.effectiveEndDate != null ? dateFormat.format(state.effectiveEndDate!) : null,
      entryTypeCode: state.entryType!,
      sourceCode: state.source ?? '',
      elementProcessingTypeCode: state.elementProcessingType ?? '',
      subpriority: _parseInt(state.subpriority, defaultValue: 1),
      creatorTypeCode: _resolveCreatorTypeCode(state.creatorType),
      processedFlag: _ynFlag(state.processed),
      retroactiveFlag: _ynFlag(state.retroactiveEntry),
      automaticEntryFlag: _ynFlag(state.automaticEntry),
      sequenceNumber: _parseInt(state.sequenceNumber, defaultValue: 1),
      reasonText: state.reason.trim(),
      payValue: _parseDouble(state.payValue),
      amount: _parseDouble(state.amount),
      currencyCode: component.currencyCode,
      costAllocationKeyflexId: _nullableTrimmed(state.costAllocationKeyFlexfield),
      costingTypeCode: state.costingType ?? '',
      accountCode: state.accountCode.trim(),
      costCenterCode: state.costCentre.trim(),
      contextSegmentCode: state.contextSegment ?? '',
      contextValue: defaultContextValue,
      approvalStatusCode: approvalStatusCode,
      comments: defaultComments,
      sourceReference: null,
      batchId: null,
    );
  }

  static String _resolveCreatorTypeCode(String? creatorType) {
    final trimmed = creatorType?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return _creatorTypeCodeMap[AddElementFormConfig.defaultCreatorType] ?? 'USER';
    }

    return _creatorTypeCodeMap[trimmed] ?? trimmed.toUpperCase().replaceAll(' ', '_');
  }

  static String _ynFlag(bool value) => value ? 'Y' : 'N';

  static int _parseInt(String value, {required int defaultValue}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return defaultValue;
    return int.parse(trimmed);
  }

  static double _parseDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    return double.parse(trimmed);
  }

  static String? _nullableTrimmed(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
