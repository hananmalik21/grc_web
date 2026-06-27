import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';

abstract class ForfeitProcessingSummaryLocalDataSource {
  ForfeitProcessingSummary getForfeitProcessingSummary();
}

class ForfeitProcessingSummaryLocalDataSourceImpl implements ForfeitProcessingSummaryLocalDataSource {
  @override
  ForfeitProcessingSummary getForfeitProcessingSummary() {
    return ForfeitProcessingSummary(
      processingDate: DateTime(2025, 12, 31, 22, 32, 3),
      processedBy: 'HR Admin',
      totalEmployeesAffected: 3,
      totalDaysForfeited: 14.5,
      auditLogReference: 'FORFEIT-1767202323843',
    );
  }
}
