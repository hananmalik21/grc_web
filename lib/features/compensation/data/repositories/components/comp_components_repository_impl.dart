import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/components/comp_components_remote_data_source.dart';
import 'package:grc/features/compensation/domain/models/components/comp_components_page.dart';
import 'package:grc/features/compensation/domain/repositories/components/comp_components_repository.dart';

class CompComponentsRepositoryImpl implements CompComponentsRepository {
  final CompComponentsRemoteDataSource remoteDataSource;

  CompComponentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompComponentsPage> getComponents({
    required int tenantId,
    required int page,
    required int pageSize,
    int? salaryStructureId,
    String? search,
    String? category,
    String? calculationMethod,
    String? status,
  }) async {
    try {
      final dto = await remoteDataSource.getComponents(
        tenantId: tenantId,
        page: page,
        pageSize: pageSize,
        salaryStructureId: salaryStructureId,
        search: search,
        category: category,
        calculationMethod: calculationMethod,
        status: status,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch components: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteComponent({required String componentGuid, required int tenantId}) async {
    try {
      await remoteDataSource.deleteComponent(componentGuid: componentGuid, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete component: ${e.toString()}', originalError: e);
    }
  }
}
