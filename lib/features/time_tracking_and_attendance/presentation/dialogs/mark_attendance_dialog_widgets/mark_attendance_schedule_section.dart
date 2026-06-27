import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceScheduleSection extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final TextEditingController durationController;
  final bool fieldsEnabled;
  final Set<String> prefilledKeys;

  const MarkAttendanceScheduleSection({
    super.key,
    required this.state,
    required this.notifier,
    required this.durationController,
    this.fieldsEnabled = true,
    this.prefilledKeys = const {},
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;

    final durationReadOnly = prefilledKeys.contains(PrefilledFieldKey.scheduleDuration);
    final startTimeReadOnly = prefilledKeys.contains(PrefilledFieldKey.scheduleStartTime);
    final durationDisabled = durationReadOnly || !fieldsEnabled;
    final durationFillColor = durationDisabled
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final durationField = DigifyTextField(
      controller: durationController,
      labelText: 'Schedule Duration (hours)',
      hintText: 'e.g. 8',
      keyboardType: TextInputType.number,
      fillColor: durationFillColor,
      filled: true,
      readOnly: durationReadOnly || !fieldsEnabled,
      onChanged: durationReadOnly || !fieldsEnabled
          ? null
          : (value) {
              final duration = int.tryParse(value);
              notifier.setScheduleDuration(duration);
            },
    );

    if (isMobile) {
      return Column(
        children: [
          _ScheduleStartTimeField(
            state: state,
            notifier: notifier,
            enabled: fieldsEnabled,
            readOnly: startTimeReadOnly,
          ),
          Gap(14.h),
          durationField,
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ScheduleStartTimeField(
            state: state,
            notifier: notifier,
            enabled: fieldsEnabled,
            readOnly: startTimeReadOnly,
          ),
        ),
        Gap(16.w),
        Expanded(child: durationField),
      ],
    );
  }
}

class _ScheduleStartTimeField extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final bool enabled;
  final bool readOnly;

  const _ScheduleStartTimeField({
    required this.state,
    required this.notifier,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final disabled = readOnly || !enabled;
    final fillColor = disabled
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyTimePickerField(
      label: 'Schedule Start Time',
      isRequired: true,
      value: state.scheduleStartTime,
      hintText: 'Select schedule start time',
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      onTimeSelected: disabled ? null : notifier.setScheduleStartTime,
      readOnly: disabled,
      fillColor: fillColor,
    );
  }
}
