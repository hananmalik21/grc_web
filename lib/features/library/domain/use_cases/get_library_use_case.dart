import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';
import 'package:grc_web/features/library/domain/repositories/library_repository.dart';

class GetLibraryUseCase {
  const GetLibraryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryData>> call() => _repository.getLibrary();
}

