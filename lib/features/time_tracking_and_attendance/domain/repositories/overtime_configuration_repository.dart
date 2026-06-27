import '../../presentation/providers/overtime_configuration/overtime_configuration_provider.dart';
import '../models/overtime_configuration/rate_multiplier.dart';

abstract class OvertimeConfigurationRepository {
  Future<OvertimeConfiguration?> getOvertimeConfiguration({
    required String companyId,
  });

  /// Creates a rate multiplier
  Future<RateMultiplier> createRateMultiplier({
    required Map<String, dynamic> rateMultiplierData,
  });

  /// Updates a rate multiplier
  Future<RateMultiplier> updateRateMultiplier({
    required Map<String, dynamic> rateMultiplierData,
  });

  /// Deletes a rate multiplier
  Future<void> deleteRateMultiplier({
    required String companyId,
    required String rateMultiplierId,
  });

  /// Saves or updates the overtime configuration
  Future<void> saveOvertimeConfiguration({
    required String companyId,
    required Map<String, dynamic> requestBody,
    required bool isUpdating,
  });
}
