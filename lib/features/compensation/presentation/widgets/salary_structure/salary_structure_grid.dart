import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'salary_structure_card.dart';

class SalaryStructureGrid extends StatelessWidget {
  final List<SalaryStructureItem> items;
  final void Function(SalaryStructureItem item) onView;
  final void Function(SalaryStructureItem item) onEdit;
  final void Function(SalaryStructureItem item)? onDelete;
  final String? deletingGuid;

  const SalaryStructureGrid({
    super.key,
    required this.items,
    required this.onView,
    required this.onEdit,
    this.onDelete,
    this.deletingGuid,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getResponsiveColumns(context, mobile: 1, tablet: 2, web: 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.w;
        final totalSpacing = spacing * (columns - 1);
        final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 20.h,
          children: items
              .map(
                (item) => SizedBox(
                  width: cardWidth,
                  child: SalaryStructureCard(
                    item: item,
                    onView: () => onView(item),
                    onEdit: () => onEdit(item),
                    onDelete: onDelete == null ? null : () => onDelete!(item),
                    isDeleting: deletingGuid == item.structureGuid,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
