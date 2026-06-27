import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../overtime_configuration/overtime_configuration_provider.dart';
import 'new_overtime_provider.dart';
import 'overtime_enterprise_provider.dart';

class OvertimeRateTypesResult {
  final List<OvertimeTypeOption> rateTypes;
  final int otConfigId;

  const OvertimeRateTypesResult({required this.rateTypes, required this.otConfigId});
}

final overtimeRateTypesProvider = FutureProvider.autoDispose<OvertimeRateTypesResult>((ref) async {
  final enterpriseId = ref.watch(overtimeEnterpriseIdProvider);
  if (enterpriseId == null) return const OvertimeRateTypesResult(rateTypes: [], otConfigId: 0);

  final repository = ref.watch(overtimeConfigurationRepositoryProvider);
  final config = await repository.getOvertimeConfiguration(companyId: enterpriseId.toString());
  if (config == null || config.rateMultipliers.isEmpty) {
    final otConfigId = config != null ? (_parseOtConfigId(config.configInfo?.otConfigId) ?? 0) : 0;
    return OvertimeRateTypesResult(rateTypes: [], otConfigId: otConfigId);
  }

  final rateTypes = config.rateMultipliers.map(_rateMultiplierToOption).toList();
  final otConfigId = _parseOtConfigId(config.configInfo?.otConfigId) ?? 0;
  return OvertimeRateTypesResult(rateTypes: rateTypes, otConfigId: otConfigId);
});

int? _parseOtConfigId(String? value) => int.tryParse(value ?? '');

OvertimeTypeOption _rateMultiplierToOption(RateMultiplier r) {
  final multiplierNum = double.tryParse(r.multiplier) ?? 0;
  final displayMultiplier = multiplierNum == multiplierNum.truncateToDouble()
      ? '${multiplierNum.toInt()}x'
      : '${multiplierNum}x';
  final label = '${r.rateName} ($displayMultiplier)';
  final id = int.tryParse(r.otRateTypeId) ?? 0;
  return OvertimeTypeOption(id: id, label: label, multiplier: displayMultiplier);
}
