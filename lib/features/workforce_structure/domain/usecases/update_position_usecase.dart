import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';

class UpdatePositionUseCase {
  final PositionRepository repository;

  UpdatePositionUseCase({required this.repository});

  Future<Position> execute(String id, Map<String, dynamic> positionData, {int? tenantId}) async {
    return await repository.updatePosition(id, positionData, tenantId: tenantId);
  }
}
