import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';

class GetWorkPatternsUseCase {
  final WorkPatternRepository repository;

  GetWorkPatternsUseCase({required this.repository});

  Future<PaginatedWorkPatterns> call({int page = 1, int pageSize = 10}) async {
    try {
      return await repository.getWorkPatterns(page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get work patterns: ${e.toString()}', originalError: e);
    }
  }
}
