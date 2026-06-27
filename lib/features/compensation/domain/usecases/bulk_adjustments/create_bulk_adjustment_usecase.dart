import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';
import 'package:grc/features/compensation/domain/repositories/bulk_adjustments/bulk_adjustments_repository.dart';

class CreateBulkAdjustmentUseCase {
  CreateBulkAdjustmentUseCase({required this.repository});

  final BulkAdjustmentsRepository repository;

  Future<void> call({required CreateBulkAdjustmentRequest request}) {
    return repository.createBulkAdjustment(request: request);
  }
}
