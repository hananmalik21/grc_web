import 'package:grc_web/features/library/domain/entities/library_entities.dart';

abstract class LibraryRemoteDataSource {
  Future<LibraryData> getLibrary();
}

