import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime_configuration/rate_multiplier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'overtime_configuration_enterprise_provider.dart';
import 'overtime_configuration_provider.dart';

class RateMultiplierFormState {
  final String? otRateTypeId;
  final String? otRateMultiplierId;
  final String? rateCode;
  final String? rateName;
  final String? rateDescription;
  final String? categoryCode;
  final String? priorityNo;
  final String? isSystem;
  final String? isActive;
  final String? multiplier;
  final String? multiplierIsActive;
  final String? actor;
  final bool isLoading;

  RateMultiplierFormState({
    this.otRateTypeId,
    this.otRateMultiplierId,
    this.rateCode,
    this.rateName,
    this.rateDescription,
    this.categoryCode,
    this.priorityNo,
    this.isSystem = 'N',
    this.isActive = 'Y',
    this.multiplier,
    this.multiplierIsActive = 'Y',
    this.actor = 'ADMIN',
    this.isLoading = false,
  });

  RateMultiplierFormState copyWith({
    String? otRateTypeId,
    String? otRateMultiplierId,
    String? rateCode,
    String? rateName,
    String? rateDescription,
    String? categoryCode,
    String? priorityNo,
    String? isSystem,
    String? isActive,
    String? multiplier,
    String? multiplierIsActive,
    String? actor,
    bool? isLoading,
  }) {
    return RateMultiplierFormState(
      otRateTypeId: otRateTypeId ?? this.otRateTypeId,
      otRateMultiplierId: otRateMultiplierId ?? this.otRateMultiplierId,
      rateCode: rateCode ?? this.rateCode,
      rateName: rateName ?? this.rateName,
      rateDescription: rateDescription ?? this.rateDescription,
      categoryCode: categoryCode ?? this.categoryCode,
      priorityNo: priorityNo ?? this.priorityNo,
      isSystem: isSystem ?? this.isSystem,
      isActive: isActive ?? this.isActive,
      multiplier: multiplier ?? this.multiplier,
      multiplierIsActive: multiplierIsActive ?? this.multiplierIsActive,
      actor: actor ?? this.actor,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final rateMultiplierDialogProvider =
    StateNotifierProvider<
      RateMultiplierDialogNotifier,
      RateMultiplierFormState
    >((ref) => RateMultiplierDialogNotifier());

class RateMultiplierDialogNotifier
    extends StateNotifier<RateMultiplierFormState> {
  RateMultiplierDialogNotifier() : super(RateMultiplierFormState());

  void setInitialData(RateMultiplier? rateMultiplier) {
    if (rateMultiplier != null) {
      state = state.copyWith(
        otRateTypeId: rateMultiplier.otRateTypeId,
        otRateMultiplierId: rateMultiplier.otRateMultiplierId,
        rateCode: rateMultiplier.rateCode,
        rateName: rateMultiplier.rateName,
        rateDescription: rateMultiplier.rateDescription,
        categoryCode: rateMultiplier.categoryCode,
        multiplier: rateMultiplier.multiplier,
      );
    } else {
      state = RateMultiplierFormState();
    }
  }

  void updateRateCode(String rateCode) {
    state = state.copyWith(rateCode: rateCode);
  }

  void updateRateTypeName(String name) {
    state = state.copyWith(rateName: name);
  }

  void updateMultiplier(String multiplier) {
    state = state.copyWith(multiplier: multiplier);
  }

  void updateCategory(String category) {
    state = state.copyWith(categoryCode: category);
  }

  void updateDescription(String description) {
    state = state.copyWith(rateDescription: description);
  }

  void reset() {
    state = RateMultiplierFormState();
  }

  Future<void> handleSubmit(WidgetRef ref) async {
    final enterpriseId = ref.read(overtimeConfigurationEnterpriseIdProvider);
    final otConfigId = ref
        .read(overtimeConfigurationProvider)
        .configInfo
        ?.otConfigId;
    final repository = ref.read(overtimeConfigurationRepositoryProvider);
    final overtimeConfigurationNotifier = ref.read(
      overtimeConfigurationProvider.notifier,
    );
    final currentState = state;
    if (enterpriseId == null ||
        otConfigId == null ||
        currentState.rateCode == null ||
        currentState.rateName == null ||
        currentState.categoryCode == null ||
        currentState.multiplier == null) {
      throw MissingRateMultiplierRequiredDataException();
    }

    state = state.copyWith(isLoading: true);

    try {
      final body = _createRequestBody(
        companyId: enterpriseId,
        otConfigId: otConfigId,
        state: state,
      );

      final isUpdating =
          state.otRateTypeId != null && state.otRateTypeId!.isNotEmpty;
      if (isUpdating) {
        body['ot_rate_type_id'] = state.otRateTypeId;
        if (state.otRateMultiplierId != null &&
            state.otRateMultiplierId!.isNotEmpty) {
          body['ot_rate_multiplier_id'] = state.otRateMultiplierId;
        }
        await repository.updateRateMultiplier(rateMultiplierData: body);
      } else {
        await repository.createRateMultiplier(rateMultiplierData: body);
      }

      await overtimeConfigurationNotifier.refresh();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Map<String, dynamic> _createRequestBody({
    required int companyId,
    required String otConfigId,
    required RateMultiplierFormState state,
  }) {
    return {
      'enterprise_id': companyId,
      'ot_config_id': otConfigId,
      'rate_code': state.rateCode,
      'rate_name': state.rateName,
      'rate_description': state.rateDescription,
      'category_code': state.categoryCode?.toUpperCase(),
      'priority_no': state.priorityNo,
      'is_system': state.isSystem,
      'is_active': state.isActive,
      'multiplier': state.multiplier,
      'multiplier_is_active': state.multiplierIsActive,
      'actor': state.actor,
    };
  }
}

class MissingRateMultiplierRequiredDataException implements Exception {
  const MissingRateMultiplierRequiredDataException();
}
