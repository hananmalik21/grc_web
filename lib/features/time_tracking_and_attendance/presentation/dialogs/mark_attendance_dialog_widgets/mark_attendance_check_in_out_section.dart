import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart'
    show MarkAttendanceFormNotifier, MarkAttendanceFormState, PrefilledFieldKey;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceCheckInOutSection extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final bool enabled;
  final Set<String> prefilledKeys;

  const MarkAttendanceCheckInOutSection({
    super.key,
    required this.state,
    required this.notifier,
    this.enabled = true,
    this.prefilledKeys = const {},
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final checkInReadOnly = prefilledKeys.contains(PrefilledFieldKey.checkInTime);
    final checkOutReadOnly = prefilledKeys.contains(PrefilledFieldKey.checkOutTime);

    if (isMobile) {
      return Column(
        children: [
          _CheckInTimeField(
            state: state,
            notifier: notifier,
            enabled: enabled && !checkInReadOnly,
            onTimeSelected: notifier.setCheckInTime,
          ),
          Gap(14.h),
          _CheckOutTimeField(
            state: state,
            notifier: notifier,
            enabled: enabled && !checkOutReadOnly,
            onTimeSelected: notifier.setCheckOutTime,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _CheckInTimeField(
            state: state,
            notifier: notifier,
            enabled: enabled && !checkInReadOnly,
            onTimeSelected: notifier.setCheckInTime,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: _CheckOutTimeField(
            state: state,
            notifier: notifier,
            enabled: enabled && !checkOutReadOnly,
            onTimeSelected: notifier.setCheckOutTime,
          ),
        ),
      ],
    );
  }
}

class _CheckInTimeField extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final bool enabled;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const _CheckInTimeField({required this.state, required this.notifier, this.enabled = true, this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = !enabled
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyTimePickerField(
      label: 'Check In Time',
      isRequired: true,
      value: state.checkInTime,
      hintText: 'Select check-in time',
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      onTimeSelected: onTimeSelected,
      readOnly: !enabled,
      fillColor: fillColor,
    );
  }
}

class _CheckOutTimeField extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final bool enabled;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const _CheckOutTimeField({required this.state, required this.notifier, this.enabled = true, this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = !enabled
        ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    return DigifyTimePickerField(
      label: 'Check Out Time',
      isRequired: true,
      value: state.checkOutTime,
      hintText: 'Select check-out time',
      initialTime: const TimeOfDay(hour: 17, minute: 0),
      onTimeSelected: onTimeSelected,
      readOnly: !enabled,
      fillColor: fillColor,
    );
  }
}
