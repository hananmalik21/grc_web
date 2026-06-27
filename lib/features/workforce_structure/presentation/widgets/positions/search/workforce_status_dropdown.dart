import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceStatusDropdown extends ConsumerWidget {
  final bool isDark;
  final String label;
  final double? width;

  const WorkforceStatusDropdown({super.key, required this.isDark, required this.label, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = ref.watch(positionNotifierProvider.select((s) => s.status));

    return SizedBox(
      width: width ?? 144.w,
      child: DigifySelectField<PositionStatus?>(
        hint: label,
        value: currentStatus,
        items: [null, ...PositionStatus.values],
        itemLabelBuilder: (status) => status?.label ?? label,
        onChanged: (newValue) {
          ref.read(positionNotifierProvider.notifier).setStatus(newValue);
        },
      ),
    );
  }
}
