import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';

abstract class ForfeitProcessingSummaryRepository {
  Future<ForfeitProcessingSummary> getForfeitProcessingSummary();
}
