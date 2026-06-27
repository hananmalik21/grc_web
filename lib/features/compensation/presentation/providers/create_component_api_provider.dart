import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_component_api_state.dart';

final _createComponentApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final createComponentApiProvider =
    StateNotifierProvider.autoDispose<CreateComponentApiNotifier, CreateComponentApiState>((ref) {
      return CreateComponentApiNotifier(ref);
    });

class CreateComponentApiNotifier extends StateNotifier<CreateComponentApiState> {
  CreateComponentApiNotifier(this._ref) : super(const CreateComponentApiState.idle());

  final Ref _ref;

  Future<String?> submit(CreateNewComponentState formState) async {
    final tenantId = _ref.read(componentsTabEnterpriseIdProvider);
    if (tenantId == null) {
      state = const CreateComponentApiState.failure('No tenant selected.');
      return state.errorMessage;
    }

    final payload = _buildPayload(formState, tenantId: tenantId, createdBy: 'SYSTEM');
    if (payload == null) {
      state = const CreateComponentApiState.failure('Missing required data to submit.');
      return state.errorMessage;
    }

    state = const CreateComponentApiState.loading();
    try {
      final apiClient = _ref.read(_createComponentApiClientProvider);
      await apiClient.post(ApiEndpoints.compComponents, body: payload, headers: _buildHeaders());
      state = const CreateComponentApiState.success();
      return null;
    } on AppException catch (e) {
      final msg = e.message.isNotEmpty ? e.message : 'Failed to create component.';
      state = CreateComponentApiState.failure(msg);
      return msg;
    } catch (e) {
      final msg = 'Failed to create component: ${e.toString()}';
      state = CreateComponentApiState.failure(msg);
      return msg;
    }
  }

  Map<String, String> _buildHeaders() {
    // Keep consistent with other data sources in the app.
    return {'x-user-id': 'admin'};
  }

  static Map<String, dynamic>? _buildPayload(
    CreateNewComponentState s, {
    required int tenantId,
    required String createdBy,
  }) {
    final componentTypeCode = _mapComponentTypeCode(s.type);
    final calcMethodCode = _mapCalculationMethodCode(s.calculationMethod);
    final compCategoryCode = _mapCompCategoryCode(s.category);
    final currencyCode = _currencyCodeFromDisplay(s.currency);
    final status = _mapStatus(s.status);

    if (componentTypeCode == null ||
        calcMethodCode == null ||
        compCategoryCode == null ||
        currencyCode == null ||
        status == null) {
      return null;
    }

    final min = num.tryParse(s.minValue.trim());
    final max = num.tryParse(s.maxValue.trim());
    if (min == null || max == null) return null;

    final effectiveStart = s.effectiveFrom == null ? null : _formatYyyyMmDd(s.effectiveFrom!);
    if (effectiveStart == null) return null;

    final effectiveEnd = s.effectiveTo == null ? null : _formatYyyyMmDd(s.effectiveTo!);

    final allEmployees = s.locations.isEmpty;

    return <String, dynamic>{
      'tenant_id': tenantId,
      'component_code': s.code.trim(),
      'component_name': s.name.trim(),
      'description': s.description.trim().isEmpty ? null : s.description.trim(),
      'component_type_code': componentTypeCode,
      'calculation_method_code': calcMethodCode,
      'pay_basis': s.payBasis,
      'base_amount_source': s.baseAmountSource,
      'formula_name': s.formulaName,
      'min_value': min,
      'max_value': max,
      'currency_code': currencyCode,
      'status': status,
      'active_flag': status == 'ACTIVE' ? 'Y' : 'N',
      'comp_category_code': compCategoryCode,
      'effective_start_date': effectiveStart,
      'effective_end_date': effectiveEnd,
      'flags': <String, dynamic>{
        'recurring_flag': s.isRecurring ? 'Y' : 'N',
        'optional_flag': s.isOptional ? 'Y' : 'N',
        'pensionable_flag': s.isPensionable ? 'Y' : 'N',
        'statutory_flag': s.isStatutory ? 'Y' : 'N',
        'include_in_ctc_flag': s.includeInCtc ? 'Y' : 'N',
        'prorated_flag': s.isProRated ? 'Y' : 'N',
        'taxable_flag': s.isTaxable ? 'Y' : 'N',
        'amortizable_flag': s.isAmortizable ? 'Y' : 'N',
      },
      'eligibility': <String, dynamic>{
        'all_employees_flag': allEmployees ? 'Y' : 'N',
        'location_codes': s.locations.map(_maybeCodeFromLabel).toList(),
      },
      'created_by': createdBy,
    };
  }

  static String? _mapComponentTypeCode(String? uiValue) {
    if (uiValue == null) return null;
    final v = uiValue.trim();
    if (v.isEmpty) return null;
    // If we are already storing lookup codes, pass them through.
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(v)) return v;
    return switch (v) {
      'FIXED' => 'FIXED',
      'VARIABLE' => 'VARIABLE',
      'PERCENTAGE' => 'PERCENTAGE',
      'Fixed' => 'FIXED',
      'Variable' => 'VARIABLE',
      'Percentage' => 'PERCENTAGE',
      _ => null,
    };
  }

  static String? _mapCalculationMethodCode(String? uiValue) {
    if (uiValue == null) return null;
    final v = uiValue.trim();
    if (v.isEmpty) return null;
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(v)) return v;
    return switch (v) {
      'AMOUNT' => 'AMOUNT',
      'PERCENTAGE' => 'PERCENTAGE',
      'FORMULA' => 'FORMULA',
      'Fixed Amount' => 'AMOUNT',
      'Percentage of Basic' => 'PERCENTAGE',
      'Percentage of Gross' => 'PERCENTAGE',
      'Formula-based' => 'FORMULA',
      _ => null,
    };
  }

  static String? _mapCompCategoryCode(String? uiValue) {
    if (uiValue == null) return null;
    final v = uiValue.trim();
    if (v.isEmpty) return null;
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(v)) return v;
    return switch (v) {
      'Deduction' => 'DEDUCTION',
      'Allowance' || 'Benefit' || 'Overtime' => 'EARNING',
      _ => null,
    };
  }

  static String? _currencyCodeFromDisplay(String uiValue) {
    final trimmed = uiValue.trim();
    if (trimmed.isEmpty) return null;
    if (!trimmed.contains('-')) return trimmed;
    final parts = trimmed.split(RegExp(r'\s*-\s*'));
    final code = parts.first.trim();
    return code.isEmpty ? null : code;
  }

  static String? _mapStatus(String uiValue) {
    return switch (uiValue.trim()) {
      'Active' => 'ACTIVE',
      'Inactive' => 'INACTIVE',
      _ => null,
    };
  }

  static String _formatYyyyMmDd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static String _codeFromLabel(String label) => label.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_');

  static String _maybeCodeFromLabel(String value) {
    final v = value.trim();
    if (v.isEmpty) return v;
    // If the UI already stores lookup codes like "PAKISTAN", keep them.
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(v)) return v;
    return _codeFromLabel(v);
  }
}
