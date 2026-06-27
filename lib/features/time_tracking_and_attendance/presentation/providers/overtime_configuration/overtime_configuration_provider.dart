import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../../../data/repositories/overtime_configuration_repository_impl.dart';
import '../../../domain/models/overtime_configuration/config_info.dart';
import '../../../domain/models/overtime_configuration/labor_law_limits.dart';
import '../../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../../../domain/repositories/overtime_configuration_repository.dart';
import '../../../domain/usecases/overtime_configuration/get_overtime_configuration_usecase.dart';

class OvertimeConfiguration {
  final bool isLoading;
  final bool clearError;
  final bool isError;
  final GlobalKey<FormState>? formKey;
  final String companyId;
  final ConfigInfo? configInfo;
  final List<RateMultiplier> rateMultipliers;
  final LaborLawLimit? laborLawLimits;
  final bool isManagerApprovalRequired;
  final bool isHRValidationRequired;
  final String error;

  OvertimeConfiguration({
    this.isLoading = false,
    this.clearError = false,
    this.isError = false,
    this.formKey,
    this.companyId = '',
    this.configInfo,
    this.error = '',
    this.rateMultipliers = const [],
    this.laborLawLimits,
    this.isManagerApprovalRequired = false,
    this.isHRValidationRequired = false,
  });

  OvertimeConfiguration copyWith({
    bool? isLoading,
    bool? clearError,
    bool? isError,
    String? companyId,
    ConfigInfo? configInfo,
    String? error,
    List<RateMultiplier>? rateMultipliers,
    LaborLawLimit? laborLawLimits,
    bool? isManagerApprovalRequired,
    bool? isHRValidationRequired,
  }) {
    return OvertimeConfiguration(
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      isError: isError ?? this.isError,
      companyId: companyId ?? this.companyId,
      configInfo: configInfo ?? this.configInfo,
      error: error ?? this.error,
      rateMultipliers: rateMultipliers ?? this.rateMultipliers,
      laborLawLimits: laborLawLimits ?? this.laborLawLimits,
      isManagerApprovalRequired:
          isManagerApprovalRequired ?? this.isManagerApprovalRequired,
      isHRValidationRequired:
          isHRValidationRequired ?? this.isHRValidationRequired,
    );
  }
}

final overtimeConfigurationApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final overtimeConfigurationRepositoryProvider =
    Provider<OvertimeConfigurationRepository>((ref) {
      final client = ref.watch(overtimeConfigurationApiClientProvider);
      return OvertimeConfigurationRepositoryImpl(apiClient: client);
    });

class MissingOvertimeConfigurationException implements Exception {
  MissingOvertimeConfigurationException();
}

class OvertimeConfigurationNotifier
    extends StateNotifier<OvertimeConfiguration> {
  final GetOvertimeConfigurationUseCase _getConfiguration;
  final OvertimeConfigurationRepository _repository;

  OvertimeConfigurationNotifier({
    required GetOvertimeConfigurationUseCase getConfiguration,
    required OvertimeConfigurationRepository repository,
  }) : _getConfiguration = getConfiguration,
       _repository = repository,
       super(OvertimeConfiguration()) {
    loadOvertimeConfigurations();
  }

  /// Loads timesheets from repository
  Future<void> loadOvertimeConfigurations() async {
    if (state.companyId.isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _getConfiguration(companyId: state.companyId);

      state = state.copyWith(
        configInfo: data?.configInfo,
        rateMultipliers: data?.rateMultipliers,
        laborLawLimits: data?.laborLawLimits,
        isManagerApprovalRequired: data?.isManagerApprovalRequired,
        isHRValidationRequired: data?.isHRValidationRequired,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load configuration: ${e.toString()}',
        clearError: false,
      );
    }
  }

  /// Refresh Overtime Configuration
  Future<void> refresh() async {
    await loadOvertimeConfigurations();
  }

  /// Set Company ID
  void setCompanyId(String? companyId) {
    state = state.copyWith(companyId: companyId);
    loadOvertimeConfigurations();
  }

  /// Update Configuration Information
  void updateConfigurationName(String name) {
    state = state.copyWith(
      configInfo: state.configInfo?.copyWith(configName: name),
    );
  }

  void updateEffectiveStartDate(DateTime date) {
    state = state.copyWith(
      configInfo: state.configInfo?.copyWith(effectiveStartDate: date),
    );
  }

  void updateEffectiveEndDate(DateTime date) {
    state = state.copyWith(
      configInfo: state.configInfo?.copyWith(effectiveEndDate: date),
    );
  }

  /// Update Labor Law Limits
  void updateLaborLawLimitsMaxDailyOvertime(String maxDailyOvertime) {
    state = state.copyWith(
      laborLawLimits: state.laborLawLimits?.copyWith(
        maxDailyOvertime: maxDailyOvertime,
      ),
    );
  }

  void updateLaborLawLimitsMaxAnnualOvertime(String maxAnnualOvertime) {
    state = state.copyWith(
      laborLawLimits: state.laborLawLimits?.copyWith(
        maxAnnualOvertime: maxAnnualOvertime,
      ),
    );
  }

  void updateLaborLawLimitsMinRestPeriod(String minRestPeriod) {
    state = state.copyWith(
      laborLawLimits: state.laborLawLimits?.copyWith(
        minRestPeriod: minRestPeriod,
      ),
    );
  }

  void updateLaborLawLimitsLawReference(String lawReference) {
    state = state.copyWith(
      laborLawLimits: state.laborLawLimits?.copyWith(
        lawReference: lawReference,
      ),
    );
  }

  void updateLaborLawLimitsNotes(String notes) {
    state = state.copyWith(
      laborLawLimits: state.laborLawLimits?.copyWith(notes: notes),
    );
  }

  /// Toggle Manager Approval
  void toggleManagerApprovalRequired(bool value) {
    state = state.copyWith(isManagerApprovalRequired: value);
  }

  /// Toggle HR Validation
  void toggleHRValidationRequired(bool value) {
    state = state.copyWith(isHRValidationRequired: value);
  }

  /// Delete Rate Type
  Future<void> deleteRateMultiplier(String rateMultiplierId) async {
    if (state.companyId.isEmpty) return;

    try {
      await _repository.deleteRateMultiplier(
        companyId: state.companyId,
        rateMultiplierId: rateMultiplierId,
      );

      state = state.copyWith(
        rateMultipliers: state.rateMultipliers
            .where((e) => e.otRateTypeId != rateMultiplierId)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete rate multiplier: ${e.toString()}',
        clearError: false,
      );
    }
  }

  /// Save Overtime Configuration
  Future<void> saveOvertimeConfiguration() async {
    if (state.companyId.isEmpty ||
        state.configInfo?.configName.isEmpty == true ||
        state.configInfo?.effectiveStartDate == null ||
        state.configInfo?.effectiveEndDate == null ||
        state.laborLawLimits?.maxDailyOvertime.isEmpty == true ||
        state.laborLawLimits?.maxAnnualOvertime.isEmpty == true ||
        state.laborLawLimits?.minRestPeriod.isEmpty == true ||
        state.laborLawLimits?.lawReference.isEmpty == true) {
      throw MissingOvertimeConfigurationException();
    }

    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final requestBody = _createRequestBody(
        companyId: state.companyId,
        configInfo: state.configInfo!,
        laborLawLimits: state.laborLawLimits!,
      );

      final isUpdating = state.configInfo?.otConfigId != null;

      if (isUpdating) {
        requestBody['ot_config_id'] = state.configInfo?.otConfigId;
        requestBody['ot_labor_limit_id'] = state.laborLawLimits?.otLaborLimitId;
      }

      await _repository.saveOvertimeConfiguration(
        companyId: state.companyId,
        requestBody: requestBody,
        isUpdating: isUpdating,
      );

      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save overtime configuration: ${e.toString()}',
        clearError: false,
      );
    }
  }

  Map<String, dynamic> _createRequestBody({
    required String companyId,
    required ConfigInfo configInfo,
    required LaborLawLimit laborLawLimits,
  }) {
    return {
      'enterprise_id': companyId,
      'config_name': configInfo.configName,
      'effective_start_date': DateFormat(
        'yyyy-MM-dd',
      ).format(configInfo.effectiveStartDate!),
      'effective_end_date': DateFormat(
        'yyyy-MM-dd',
      ).format(configInfo.effectiveEndDate!),
      'status': "ACTIVE",
      "labor_limits": {
        "max_daily_overtime_hours": laborLawLimits.maxDailyOvertime,
        "max_annual_overtime_hours": laborLawLimits.maxAnnualOvertime,
        "min_rest_period_hours": laborLawLimits.minRestPeriod,
        "law_reference": laborLawLimits.lawReference,
        "notes": laborLawLimits.notes,
      },
      "actor": "ADMIN",
    };
  }
}

final overtimeConfigurationProvider =
    StateNotifierProvider<OvertimeConfigurationNotifier, OvertimeConfiguration>(
      (ref) {
        final repository = ref.watch(overtimeConfigurationRepositoryProvider);
        final getConfigurationUseCase = GetOvertimeConfigurationUseCase(
          repository: repository,
        );
        return OvertimeConfigurationNotifier(
          repository: repository,
          getConfiguration: getConfigurationUseCase,
        );
      },
    );
