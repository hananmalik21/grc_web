import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/assets/data/data_sources/assets_remote_data_source.dart';
import 'package:grc_web/features/assets/data/data_sources/assets_remote_data_source_impl.dart';
import 'package:grc_web/features/assets/data/repositories/assets_repository_impl.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';
import 'package:grc_web/features/assets/domain/repositories/assets_repository.dart';
import 'package:grc_web/features/assets/domain/use_cases/get_assets_use_case.dart';

final assetsRemoteDataSourceProvider = Provider<AssetsRemoteDataSource>((ref) {
  return AssetsRemoteDataSourceImpl(ref.watch(dioProvider));
});

final assetsRepositoryProvider = Provider<AssetsRepository>((ref) {
  return AssetsRepositoryImpl(ref.watch(assetsRemoteDataSourceProvider));
});

final getAssetsUseCaseProvider = Provider<GetAssetsUseCase>((ref) {
  return GetAssetsUseCase(ref.watch(assetsRepositoryProvider));
});

class AssetsNotifier extends AsyncNotifier<AssetsData> {
  @override
  Future<AssetsData> build() async {
    final result = await ref.read(getAssetsUseCaseProvider)();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}

final assetsProvider = AsyncNotifierProvider<AssetsNotifier, AssetsData>(AssetsNotifier.new);
