import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/gen/assets.gen.dart';
import '../../providers/overtime/new_overtime_attendance_day_id_provider.dart';
import '../../providers/overtime/new_overtime_provider.dart';
import '../../providers/overtime/overtime_enterprise_provider.dart';
import 'new_overtime_request_overtime_type_field.dart';

class NewOvertimeRequestFormBody extends ConsumerWidget {
  const NewOvertimeRequestFormBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(newOvertimeRequestProvider.notifier);
    final state = ref.watch(newOvertimeRequestProvider);
    final enterpriseId = ref.watch(overtimeEnterpriseIdProvider);
    final attendanceAsync = ref.watch(newOvertimeAttendanceDayIdProvider);

    final hasEnterprise = enterpriseId != null && enterpriseId > 0;
    final hasEmployee = state.selectedEmployee != null;
    final result = attendanceAsync.valueOrNull;
    final hasAttendanceId = (result?.attendanceDayId ?? 0) > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasEnterprise)
          EmployeeSearchField(
            label: 'EMPLOYEE',
            isRequired: true,
            enterpriseId: enterpriseId,
            selectedEmployee: state.selectedEmployee,
            hintText: 'Type to search employees...',
            onEmployeeSelected: notifier.setEmployeeFromSelection,
          )
        else
          _EmployeeFieldPlaceholder(),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDateField(context, state, notifier, hasEmployee)),
            Gap(16.w),
            Expanded(child: NewOvertimeRequestOvertimeTypeField()),
          ],
        ),
        if (hasEmployee && state.date != null) _DateAttendanceStatus(),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                key: ValueKey('ot_hours_${state.date?.toIso8601String().split('T').first ?? ''}'),
                labelText: 'NUMBER OF HOURS',
                isRequired: true,
                hintText: 'Type number of hours',
                onChanged: notifier.setNumberOfHours,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: hasAttendanceId,
                prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                  child: DigifyAsset(
                    assetPath: Assets.icons.clockIcon.path,
                    width: 20,
                    height: 20,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                  ),
                ),
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                key: ValueKey(state.estimatedRate ?? ''),
                labelText: 'ESTIMATED RATE',
                initialValue: state.estimatedRate,
                readOnly: true,
                hintText: '--',
              ),
            ),
          ],
        ),
        Gap(16.h),
        DigifyTextArea(
          labelText: 'JUSTIFICATION / REASON',
          isRequired: true,
          onChanged: notifier.setReason,
          hintText: 'Provide a detailed reason for the overtime requirement...',
          maxLines: 5,
          readOnly: !hasAttendanceId,
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    NewOvertimeRequestFormState state,
    NewOvertimeRequestNotifier notifier,
    bool hasEmployee,
  ) {
    final isDisabled = !hasEmployee;

    return DigifyDateField(
      label: 'OVERTIME DATE',
      hintText: isDisabled ? 'Select employee first' : 'Select overtime date',
      initialDate: state.date,
      onDateSelected: isDisabled ? null : notifier.setDate,
      isRequired: true,
      readOnly: isDisabled,
    );
  }
}

class _DateAttendanceStatus extends ConsumerWidget {
  const _DateAttendanceStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(newOvertimeAttendanceDayIdProvider);
    return attendanceAsync.when(
      data: (result) {
        if ((result.attendanceDayId ?? 0) > 0) return const SizedBox.shrink();
        return Text(
          'No attendance record found for this date. Please ensure attendance is marked.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(type: LoadingType.circle, size: 14.r),
            Gap(8.w),
            Text('Checking attendance for this date...', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      error: (_, _) => Text(
        'Failed to load attendance. Please try a different date.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

class _EmployeeFieldPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final disabledFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;
    return DigifyTextField(
      labelText: 'EMPLOYEE',
      isRequired: true,
      readOnly: true,
      hintText: 'Select an enterprise first',
      filled: true,
      fillColor: disabledFillColor,
    );
  }
}
