import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/structure_list_repository.dart';

class GetStructureListUseCase {
  final StructureListRepository repository;

  GetStructureListUseCase({required this.repository});

  Future<PaginatedStructureList> call({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('Page number must be greater than 0');
      }
      if (pageSize < 1) {
        throw ValidationException('Page size must be greater than 0');
      }

      return await repository.getStructures(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get structure list: ${e.toString()}', originalError: e);
    }
  }
}
