import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';

/// Get positions use case
/// Encapsulates the business logic for fetching positions
class GetPositionsUseCase {
  final PositionRepository repository;

  const GetPositionsUseCase({required this.repository});

  Future<PositionResponse> call({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  }) async {
    return await repository.getPositions(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      tenantId: tenantId,
    );
  }
}
