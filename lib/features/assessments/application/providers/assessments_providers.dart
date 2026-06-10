import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/assessments/data/data_sources/assessments_remote_data_source.dart';
import 'package:grc_web/features/assessments/data/data_sources/assessments_remote_data_source_impl.dart';
import 'package:grc_web/features/assessments/data/repositories/assessments_repository_impl.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';
import 'package:grc_web/features/assessments/domain/repositories/assessments_repository.dart';
import 'package:grc_web/features/assessments/domain/use_cases/get_assessments_use_case.dart';

final assessmentsRemoteDataSourceProvider =
    Provider<AssessmentsRemoteDataSource>((ref) {
  return AssessmentsRemoteDataSourceImpl(ref.watch(dioProvider));
});

final assessmentsRepositoryProvider = Provider<AssessmentsRepository>((ref) {
  return AssessmentsRepositoryImpl(ref.watch(assessmentsRemoteDataSourceProvider));
});

final getAssessmentsUseCaseProvider = Provider<GetAssessmentsUseCase>((ref) {
  return GetAssessmentsUseCase(ref.watch(assessmentsRepositoryProvider));
});

final getFrameworkDetailUseCaseProvider =
    Provider<GetFrameworkDetailUseCase>((ref) {
  return GetFrameworkDetailUseCase(ref.watch(assessmentsRepositoryProvider));
});

final frameworkDetailProvider =
    FutureProvider.family<FrameworkDetail, String>((ref, frameworkName) async {
  final result = await ref.read(getFrameworkDetailUseCaseProvider)(frameworkName);
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});

class AssessmentsNotifier extends AsyncNotifier<AssessmentsData> {
  @override
  Future<AssessmentsData> build() async {
    final result = await ref.read(getAssessmentsUseCaseProvider)();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}

final assessmentsProvider =
    AsyncNotifierProvider<AssessmentsNotifier, AssessmentsData>(
        AssessmentsNotifier.new);
