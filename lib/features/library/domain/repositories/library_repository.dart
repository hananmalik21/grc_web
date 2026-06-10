import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';

abstract class LibraryRepository {
  Future<Result<LibraryData>> getLibrary();
}

