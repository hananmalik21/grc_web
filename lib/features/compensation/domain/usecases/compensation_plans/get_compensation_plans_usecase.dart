import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plans_page.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class GetCompensationPlansUseCase {
  final CompensationPlansRepository repository;

  const GetCompensationPlansUseCase({required this.repository});

  Future<CompensationPlansPage> call({
    required int enterpriseId,
    required int page,
    required int limit,
    String? search,
    String? planTypeCode,
    String? currencyCode,
    String? statusCode,
  }) {
    return repository.getCompensationPlans(
      enterpriseId: enterpriseId,
      page: page,
      limit: limit,
      search: search,
      planTypeCode: planTypeCode,
      currencyCode: currencyCode,
      statusCode: statusCode,
    );
  }
}
