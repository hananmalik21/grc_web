import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/risks/data/data_sources/risks_remote_data_source.dart';
import 'package:grc_web/features/risks/data/data_sources/risks_remote_data_source_impl.dart';
import 'package:grc_web/features/risks/data/repositories/risks_repository_impl.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';
import 'package:grc_web/features/risks/domain/repositories/risks_repository.dart';
import 'package:grc_web/features/risks/domain/use_cases/get_risks_use_case.dart';

final risksRemoteDataSourceProvider = Provider<RisksRemoteDataSource>((ref) {
  return RisksRemoteDataSourceImpl(ref.watch(dioProvider));
});

final risksRepositoryProvider = Provider<RisksRepository>((ref) {
  return RisksRepositoryImpl(ref.watch(risksRemoteDataSourceProvider));
});

final getRisksUseCaseProvider = Provider<GetRisksUseCase>((ref) {
  return GetRisksUseCase(ref.watch(risksRepositoryProvider));
});

class RisksNotifier extends AsyncNotifier<RisksData> {
  @override
  Future<RisksData> build() async {
    final result = await ref.read(getRisksUseCaseProvider)();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}

final risksProvider = AsyncNotifierProvider<RisksNotifier, RisksData>(RisksNotifier.new);
