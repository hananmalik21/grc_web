import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/hierarchy_preview_widget.dart';
import 'package:flutter/material.dart';

const double _previewBaseWidth = 814.0;
const double _previewWidthDecrement = 24.0;

double _previewLevelWidth(int level) => _previewBaseWidth - (_previewWidthDecrement * (level - 1));

class HierarchyPreviewSection extends StatelessWidget {
  final List<HierarchyLevel> levels;

  const HierarchyPreviewSection({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    final activeLevels = levels.where((level) => level.isActive).toList();
    final previewLevels = activeLevels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final sequentialLevel = index + 1;
      return HierarchyPreviewLevel(
        name: level.name,
        icon: level.previewIcon,
        level: sequentialLevel,
        width: _previewLevelWidth(sequentialLevel),
      );
    }).toList();

    return HierarchyPreviewWidget(levels: previewLevels);
  }
}
