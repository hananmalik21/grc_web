import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/library/data/data_sources/library_remote_data_source.dart';
import 'package:grc_web/features/library/data/data_sources/library_remote_data_source_impl.dart';
import 'package:grc_web/features/library/data/repositories/library_repository_impl.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';
import 'package:grc_web/features/library/domain/repositories/library_repository.dart';
import 'package:grc_web/features/library/domain/use_cases/get_library_use_case.dart';

final libraryRemoteDataSourceProvider = Provider<LibraryRemoteDataSource>((ref) {
  return LibraryRemoteDataSourceImpl(ref.watch(dioProvider));
});

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl(ref.watch(libraryRemoteDataSourceProvider));
});

final getLibraryUseCaseProvider = Provider<GetLibraryUseCase>((ref) {
  return GetLibraryUseCase(ref.watch(libraryRepositoryProvider));
});

class LibraryNotifier extends AsyncNotifier<LibraryData> {
  @override
  Future<LibraryData> build() async {
    final result = await ref.read(getLibraryUseCaseProvider)();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}

final libraryProvider = AsyncNotifierProvider<LibraryNotifier, LibraryData>(LibraryNotifier.new);

