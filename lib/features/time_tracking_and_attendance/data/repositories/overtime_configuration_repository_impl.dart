import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/exceptions.dart';
import '../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../../domain/repositories/overtime_configuration_repository.dart';
import '../../presentation/providers/overtime_configuration/overtime_configuration_provider.dart';
import '../dto/overtime_configuration_dto.dart';

class OvertimeConfigurationRepositoryImpl
    implements OvertimeConfigurationRepository {
  final ApiClient? _apiClient;

  OvertimeConfigurationRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<OvertimeConfiguration?> getOvertimeConfiguration({
    required String companyId,
  }) async {
    try {
      final response = await _apiClient?.get(
        ApiEndpoints.tmOvertimeConfigurationById(companyId),
      );

      final responseData = response?['data'];
      if (responseData == null || responseData is! Map) {
        return null;
      }

      final data = OvertimeConfigurationDto.fromJson(
        Map<String, dynamic>.from(responseData),
      ).toDomain();

      return data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load overtime configuration: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<RateMultiplier> createRateMultiplier({
    required Map<String, dynamic> rateMultiplierData,
  }) async {
    try {
      final response = await _apiClient?.post(
        ApiEndpoints.tmOvertimeRateMultiplier,
        body: rateMultiplierData,
      );

      final status = response?['status'] as bool? ?? true;
      if (!status) {
        final message =
            response?['message'] as String? ?? 'Failed to create rate type';
        throw UnknownException(message);
      }

      final data = response?['data'] as Map<String, dynamic>? ?? {};

      return RateMultiplier.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create rate multiplier: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<RateMultiplier> updateRateMultiplier({
    required Map<String, dynamic> rateMultiplierData,
  }) async {
    try {
      final response = await _apiClient?.put(
        ApiEndpoints.tmOvertimeRateMultiplier,
        body: rateMultiplierData,
      );

      final status = response?['status'] as bool? ?? true;
      if (!status) {
        final message =
            response?['message'] as String? ?? 'Failed to update rate type';
        throw UnknownException(message);
      }

      final data = response?['data'] as Map<String, dynamic>? ?? {};

      return RateMultiplier.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update rate multiplier: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteRateMultiplier({
    required String companyId,
    required String rateMultiplierId,
  }) async {
    try {
      await _apiClient?.delete(
        ApiEndpoints.tmOvertimeRateMultiplier,
        body: {'enterprise_id': companyId, 'ot_rate_type_id': rateMultiplierId},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete rate multiplier: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveOvertimeConfiguration({
    required String companyId,
    required Map<String, dynamic> requestBody,
    required bool isUpdating,
  }) async {
    try {
      final endpoint = ApiEndpoints.tmOvertimeConfiguration;
      final response = isUpdating
          ? await _apiClient?.put(endpoint, body: requestBody)
          : await _apiClient?.post(endpoint, body: requestBody);

      final status = response?['status'] as bool? ?? true;
      if (!status) {
        final message =
            response?['message'] as String? ?? 'Failed to save configuration';
        throw UnknownException(message);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to save configuration: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
