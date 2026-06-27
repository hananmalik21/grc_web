import 'package:flutter/foundation.dart';

@immutable
class ActiveStructureLevel {
  final int levelId;
  final String structureId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final bool isMandatory;
  final bool isActive;
  final int displayOrder;

  const ActiveStructureLevel({
    required this.levelId,
    required this.structureId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
  });
}

