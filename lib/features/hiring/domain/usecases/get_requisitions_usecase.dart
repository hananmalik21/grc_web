import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';
import 'package:grc/features/hiring/data/dto/requisitions_dto.dart';

class GetRequisitionsUseCase {
  const GetRequisitionsUseCase({required this.repository});

  final RequisitionsRepository repository;

  Future<RequisitionsPageDto> call({required int enterpriseId, int page = 1, int pageSize = 10}) {
    return repository.getRequisitions(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
  }
}
