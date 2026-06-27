import 'package:grc/features/compensation/domain/models/components/comp_components_page.dart';

abstract class CompComponentsRepository {
  Future<CompComponentsPage> getComponents({
    required int tenantId,
    required int page,
    required int pageSize,
    int? salaryStructureId,
    String? search,
    String? category,
    String? calculationMethod,
    String? status,
  });

  Future<void> deleteComponent({required String componentGuid, required int tenantId});
}
