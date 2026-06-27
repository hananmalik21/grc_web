import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_component_api_state.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _updateComponentApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final updateComponentApiProvider = StateNotifierProvider.autoDispose
    .family<UpdateComponentApiNotifier, CreateComponentApiState, CompComponent>((ref, component) {
      return UpdateComponentApiNotifier(ref, component);
    });

class UpdateComponentApiNotifier extends StateNotifier<CreateComponentApiState> {
  UpdateComponentApiNotifier(this._ref, this._component) : super(const CreateComponentApiState.idle());

  final Ref _ref;
  final CompComponent _component;

  Future<String?> submit(UpdateComponentState formState) async {
    final tenantId = _ref.read(componentsTabEnterpriseIdProvider);
    if (tenantId == null) {
      state = const CreateComponentApiState.failure('No tenant selected.');
      return state.errorMessage;
    }

    final payload = _buildPayload(formState, tenantId: tenantId);
    if (payload == null) {
      state = const CreateComponentApiState.failure('Missing required data to submit.');
      return state.errorMessage;
    }

    state = const CreateComponentApiState.loading();
    try {
      final apiClient = _ref.read(_updateComponentApiClientProvider);
      final url = '${ApiEndpoints.compComponents}/${_component.componentGuid}';
      await apiClient.put(url, body: payload, headers: _buildHeaders());
      state = const CreateComponentApiState.success();
      return null;
    } on AppException catch (e) {
      final msg = e.message.isNotEmpty ? e.message : 'Failed to update component.';
      state = CreateComponentApiState.failure(msg);
      return msg;
    } catch (e) {
      final msg = 'Failed to update component: ${e.toString()}';
      state = CreateComponentApiState.failure(msg);
      return msg;
    }
  }

  Map<String, String> _buildHeaders() => {'x-user-id': 'admin'};

  static Map<String, dynamic>? _buildPayload(UpdateComponentState s, {required int tenantId}) {
    final calcMethodCode = _mapCalculationMethodCode(s.calculationMethod);
    final compCategoryCode = s.category;
    final componentTypeCode = s.type;
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
        'location_codes': s.locations.toList(),
      },
      'last_updated_by': 'SYSTEM',
      'updated_by': 'ADMIN',
    };
  }

  static String? _mapCalculationMethodCode(String? uiValue) {
    if (uiValue == null) return null;
    final v = uiValue.trim();
    if (v.isEmpty) return null;
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(v)) return v;
    return switch (v) {
      'Fixed Amount' => 'AMOUNT',
      'Percentage of Basic' || 'Percentage of Gross' => 'PERCENTAGE',
      'Formula-based' => 'FORMULA',
      _ => null,
    };
  }

  static String? _currencyCodeFromDisplay(String uiValue) {
    final trimmed = uiValue.trim();
    if (trimmed.isEmpty) return null;
    if (!trimmed.contains('-')) return trimmed;
    final code = trimmed.split(RegExp(r'\s*-\s*')).first.trim();
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
}
