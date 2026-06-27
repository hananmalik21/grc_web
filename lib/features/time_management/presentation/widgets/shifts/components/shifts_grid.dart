import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftsGrid extends StatelessWidget {
  final List<ShiftOverview> shifts;
  final Function(ShiftOverview) onView;
  final Function(ShiftOverview) onEdit;
  final Function(ShiftOverview) onCopy;
  final Function(ShiftOverview)? onDelete;
  final int? deletingShiftId;

  const ShiftsGrid({
    super.key,
    required this.shifts,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.deletingShiftId,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getGridColumns(context);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final spacing = 24.w;
            final totalSpacing = spacing * (columns - 1);
            final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: 24.h,
              children: shifts.map((shift) {
                return SizedBox(
                  width: cardWidth,
                  child: ShiftCard(
                    shift: shift,
                    onView: () => onView(shift),
                    onEdit: () => onEdit(shift),
                    onCopy: () => onCopy(shift),
                    onDelete: onDelete != null ? () => onDelete!(shift) : null,
                    isDeleting: deletingShiftId == shift.id,
                  ),
                );
              }).toList(),
            );
          },
        ),
        Gap(24.h),
      ],
    );
  }
}
