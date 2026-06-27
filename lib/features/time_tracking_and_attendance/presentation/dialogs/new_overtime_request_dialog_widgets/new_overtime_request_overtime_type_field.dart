import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import '../../providers/overtime/new_overtime_provider.dart';
import '../../providers/overtime/overtime_rate_types_provider.dart';
import 'new_overtime_request_overtime_type_skeleton.dart';

class NewOvertimeRequestOvertimeTypeField extends ConsumerWidget {
  final bool enabled;

  const NewOvertimeRequestOvertimeTypeField({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newOvertimeRequestProvider);
    final notifier = ref.read(newOvertimeRequestProvider.notifier);
    final rateTypesAsync = ref.watch(overtimeRateTypesProvider);
    final isDark = context.isDark;
    final disabledFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;

    return rateTypesAsync.when(
      loading: () => const NewOvertimeRequestOvertimeTypeSkeleton(),
      error: (_, _) => DigifySelectFieldWithLabel<OvertimeTypeOption>(
        label: 'OVERTIME TYPE',
        isRequired: true,
        hint: enabled ? 'Failed to load' : 'Select employee first',
        value: null,
        items: const [],
        itemLabelBuilder: (t) => t.label,
        onChanged: null,
        fillColor: enabled ? null : disabledFillColor,
      ),
      data: (result) {
        final hint = enabled
            ? (result.rateTypes.isEmpty ? 'No types configured' : 'Select overtime type')
            : 'Select employee first';
        return DigifySelectFieldWithLabel<OvertimeTypeOption>(
          label: 'OVERTIME TYPE',
          isRequired: true,
          hint: hint,
          value: state.overtimeType,
          items: result.rateTypes,
          itemLabelBuilder: (t) => t.label,
          onChanged: enabled ? notifier.setOvertimeType : null,
          fillColor: enabled ? null : disabledFillColor,
        );
      },
    );
  }
}
