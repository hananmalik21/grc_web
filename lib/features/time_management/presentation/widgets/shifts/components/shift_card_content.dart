import 'package:grc/core/utils/duration_formatter.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card_detail_row.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShiftCardContent extends StatelessWidget {
  final ShiftOverview shift;
  final bool isDark;

  const ShiftCardContent({super.key, required this.shift, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getCardPadding(context);
    final spacing = ResponsiveHelper.getCardContentSpacing(context);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShiftCardHeader(shift: shift, isDark: isDark),
          Gap(spacing),
          ShiftCardDetailRow(label: 'Time', value: '${shift.startTime} - ${shift.endTime}'),
          ShiftCardDetailRow(label: 'Duration', value: '${DurationFormatter.formatHours(shift.totalHours)} hours'),
          ShiftCardDetailRow(
            label: 'Break',
            value:
                '${DurationFormatter.formatHours(shift.breakHours.toDouble())} ${shift.breakHours == 1 ? 'hour' : 'hours'}',
          ),
          ShiftCardDetailRow(label: 'Type', value: shift.shiftTypeRaw),
        ],
      ),
    );
  }
}
