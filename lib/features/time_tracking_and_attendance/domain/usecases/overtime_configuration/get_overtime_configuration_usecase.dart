import '../../../../../core/network/exceptions.dart';
import '../../../presentation/providers/overtime_configuration/overtime_configuration_provider.dart';
import '../../repositories/overtime_configuration_repository.dart';

class GetOvertimeConfigurationUseCase {
  final OvertimeConfigurationRepository repository;

  GetOvertimeConfigurationUseCase({required this.repository});

  Future<OvertimeConfiguration?> call({required String companyId}) async {
    try {
      return await repository.getOvertimeConfiguration(companyId: companyId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get overtime configuration: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
