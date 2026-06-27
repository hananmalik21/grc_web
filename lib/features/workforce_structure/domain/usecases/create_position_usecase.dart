import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';

class CreatePositionUseCase {
  final PositionRepository repository;

  CreatePositionUseCase({required this.repository});

  Future<Position> call(Map<String, dynamic> positionData, {int? tenantId}) async {
    return await repository.createPosition(positionData, tenantId: tenantId);
  }
}
