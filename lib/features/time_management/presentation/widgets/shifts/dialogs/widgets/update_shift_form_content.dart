import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_time_picker_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/time_management/data/config/shift_form_config.dart';
import 'package:grc/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:grc/features/time_management/presentation/providers/update_shift_form_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_color_picker_field.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateShiftFormContent extends ConsumerWidget {
  final ShiftOverview shift;
  final TextEditingController codeController;
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController durationController;
  final TextEditingController breakDurationController;
  final int enterpriseId;

  const UpdateShiftFormContent({
    super.key,
    required this.shift,
    required this.codeController,
    required this.nameEnController,
    required this.nameArController,
    required this.durationController,
    required this.breakDurationController,
    required this.enterpriseId,
  });

  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isStartTime) async {
    final params = (shift: shift, enterpriseId: enterpriseId);
    final viewState = ref.read(updateShiftFormViewProvider(params));
    final currentTime = isStartTime ? viewState.formState.startTime : viewState.formState.endTime;

    final TimeOfDay? picked = await DigifyTimePickerDialog.show(
      context,
      initialTime: isStartTime
          ? (currentTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (currentTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );

    if (picked != null) {
      if (isStartTime) {
        viewState.formNotifier.updateStartTime(picked);
      } else {
        viewState.formNotifier.updateEndTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (shift: shift, enterpriseId: enterpriseId);
    final viewState = ref.watch(updateShiftFormViewProvider(params));
    final formState = viewState.formState;
    final formNotifier = viewState.formNotifier;
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Code',
                hintText: 'e.g., DAY-SHIFT',
                controller: codeController,
                isRequired: true,
                enabled: false,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Name (English)',
                hintText: 'e.g., Day Shift',
                controller: nameEnController,
                isRequired: true,
                onChanged: (value) => formNotifier.updateNameEn(value),
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Shift Name (Arabic)',
                hintText: 'Enter shift name in Arabic (Optional)',
                controller: nameArController,
                isRequired: false,
                inputFormatters: [AppInputFormatters.nameAny],
                onChanged: (value) => formNotifier.updateNameAr(value),
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifySelectFieldWithLabel<EmplLookupValue>(
                label: 'Shift Type',
                hint: viewState.isLoadingShiftTypes ? localizations.pleaseWait : localizations.selectType,
                items: viewState.shiftTypeValues,
                itemLabelBuilder: (v) => v.meaningEn,
                value: viewState.selectedShiftType,
                onChanged: viewState.isLoadingShiftTypes ? null : (v) => formNotifier.updateShiftType(v?.lookupCode),
                isRequired: true,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShiftTimePickerField(
                label: 'Start Time',
                hintText: '09:00 AM',
                time: formState.startTime,
                onTap: () => _selectTime(context, ref, true),
                isDark: isDark,
                isRequired: true,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: ShiftTimePickerField(
                label: 'End Time',
                hintText: '05:00 PM',
                time: formState.endTime,
                onTap: () => _selectTime(context, ref, false),
                isDark: isDark,
                isRequired: true,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'Duration (Hours)',
                hintText: '8',
                controller: durationController,
                isRequired: true,
                readOnly: true,
                enabled: false,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'Break Duration (Hours)',
                hintText: '1',
                controller: breakDurationController,
                readOnly: true,
                enabled: false,
              ),
            ),
          ],
        ),
        Gap(16.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ShiftColorPickerField(
                selectedColor: formState.selectedColor,
                onColorChanged: (color) => formNotifier.updateColor(color),
                isDark: isDark,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifySelectFieldWithLabel<String>(
                label: 'Status',
                items: ShiftFormConfig.statusOptions,
                itemLabelBuilder: (e) => e,
                value: formState.status,
                onChanged: (value) => formNotifier.updateStatus(value!),
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
