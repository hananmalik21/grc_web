import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';

class DeletePositionUseCase {
  final PositionRepository repository;

  DeletePositionUseCase({required this.repository});

  Future<void> execute(String id, {bool hard = true, int? tenantId}) async {
    return await repository.deletePosition(id, hard: hard, tenantId: tenantId);
  }
}
