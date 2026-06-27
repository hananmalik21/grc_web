import 'package:grc/features/leave_management/data/datasources/forfeit_processing_summary_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_processing_summary_repository.dart';

class ForfeitProcessingSummaryRepositoryImpl implements ForfeitProcessingSummaryRepository {
  final ForfeitProcessingSummaryLocalDataSource localDataSource;

  ForfeitProcessingSummaryRepositoryImpl({required this.localDataSource});

  @override
  Future<ForfeitProcessingSummary> getForfeitProcessingSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localDataSource.getForfeitProcessingSummary();
  }
}
