import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/overtime_configuration/config_info.dart';
import '../overtime_configuration/overtime_configuration_provider.dart';
import 'overtime_enterprise_provider.dart';

final overtimeConfigForRequestProvider = FutureProvider.autoDispose<ConfigInfo?>((ref) async {
  final enterpriseId = ref.watch(overtimeEnterpriseIdProvider);
  if (enterpriseId == null) return null;

  final repository = ref.watch(overtimeConfigurationRepositoryProvider);
  final config = await repository.getOvertimeConfiguration(companyId: enterpriseId.toString());
  return config?.configInfo;
});
