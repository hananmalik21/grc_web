import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/time_zone_search_field.dart';
import 'package:grc/core/widgets/forms/work_pattern_selection_field.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleFormFields extends StatefulWidget {
  final TextEditingController scheduleCodeController;
  final TextEditingController scheduleNameEnController;
  final TextEditingController scheduleNameArController;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final WorkPattern? selectedWorkPattern;
  final int enterpriseId;
  final PositionStatus selectedStatus;
  final bool isScheduleCodeDisabled;
  final ValueChanged<String>? onScheduleCodeChanged;
  final ValueChanged<String>? onScheduleNameEnChanged;
  final ValueChanged<String>? onScheduleNameArChanged;
  final ValueChanged<WorkPattern?> onWorkPatternChanged;
  final ValueChanged<PositionStatus> onStatusChanged;
  final ValueChanged<DateTime>? onStartDateSelected;
  final ValueChanged<DateTime>? onEndDateSelected;
  final TimeZone? selectedTimeZone;
  final ValueChanged<TimeZone?>? onTimeZoneChanged;

  const WorkScheduleFormFields({
    super.key,
    required this.scheduleCodeController,
    required this.scheduleNameEnController,
    required this.scheduleNameArController,
    this.initialStartDate,
    this.initialEndDate,
    this.selectedWorkPattern,
    required this.enterpriseId,
    required this.selectedStatus,
    this.isScheduleCodeDisabled = false,
    this.onScheduleCodeChanged,
    this.onScheduleNameEnChanged,
    this.onScheduleNameArChanged,
    required this.onWorkPatternChanged,
    required this.onStatusChanged,
    this.onStartDateSelected,
    this.onEndDateSelected,
    this.selectedTimeZone,
    this.onTimeZoneChanged,
  });

  @override
  State<WorkScheduleFormFields> createState() => _WorkScheduleFormFieldsState();
}

class _WorkScheduleFormFieldsState extends State<WorkScheduleFormFields> {
  @override
  Widget build(BuildContext context) {
    return _FormContent(widget: widget, isDark: context.isDark, isNarrow: context.screenLayout.isMobile);
  }
}

class _FormContent extends StatelessWidget {
  final WorkScheduleFormFields widget;
  final bool isDark;
  final bool isNarrow;

  const _FormContent({required this.widget, required this.isDark, required this.isNarrow});

  Widget _fieldPair(Widget first, Widget second) {
    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [first, Gap(16.h), second],
      );
    }
    return Row(
      children: [
        Expanded(child: first),
        Gap(24.w),
        Expanded(child: second),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldPair(
          DigifyTextField(
            controller: widget.scheduleCodeController,
            labelText: 'Schedule Code',
            hintText: 'e.g., SCH-ADMIN-2024',
            isRequired: true,
            readOnly: widget.isScheduleCodeDisabled,
            enabled: !widget.isScheduleCodeDisabled,
            onChanged: widget.onScheduleCodeChanged,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'))],
          ),
          DigifyTextField(
            controller: widget.scheduleNameEnController,
            labelText: 'Schedule Name (English)',
            hintText: 'e.g., Admin Department Schedule 2024',
            isRequired: true,
            onChanged: widget.onScheduleNameEnChanged,
          ),
        ),
        Gap(24.h),
        _fieldPair(
          DigifyTextField(
            controller: widget.scheduleNameArController,
            labelText: 'Schedule Name (Arabic)',
            hintText: 'Enter schedule name in Arabic (Optional)',
            isRequired: false,
            onChanged: widget.onScheduleNameArChanged,
            inputFormatters: [AppInputFormatters.nameAny],
          ),
          TimeZoneSearchField(
            label: 'Time Zone',
            isRequired: true,
            selectedTimeZone: widget.selectedTimeZone,
            onTimeZoneSelected: (tz) => widget.onTimeZoneChanged?.call(tz),
            hintText: 'Search time zones (e.g. America, Europe)',
            fillColor: isDark ? AppColors.inputBgDark : Colors.transparent,
          ),
        ),
        Gap(24.h),
        WorkPatternSelectionField(
          label: 'Work Pattern',
          isRequired: true,
          enterpriseId: widget.enterpriseId,
          selectedWorkPattern: widget.selectedWorkPattern,
          onChanged: widget.onWorkPatternChanged,
        ),
        Gap(24.h),
        _fieldPair(
          DigifyDateField(
            label: 'Effective Start Date',
            hintText: 'YYYY-MM-DD',
            isRequired: true,
            initialDate: widget.initialStartDate,
            lastDate: DateTime(2100),
            onDateSelected: widget.onStartDateSelected,
            fillColor: isDark ? AppColors.inputBgDark : Colors.transparent,
          ),
          DigifyDateField(
            label: 'Effective End Date',
            hintText: 'YYYY-MM-DD (optional)',
            isRequired: false,
            initialDate: widget.initialEndDate,
            onDateSelected: widget.onEndDateSelected,
            lastDate: DateTime(2100),
            fillColor: isDark ? AppColors.inputBgDark : Colors.transparent,
          ),
        ),
        Gap(24.h),
        if (isNarrow)
          DigifySelectFieldWithLabel<PositionStatus>(
            label: 'Status',
            value: widget.selectedStatus,
            items: [PositionStatus.active, PositionStatus.inactive],
            itemLabelBuilder: (status) => status == PositionStatus.active ? 'Active' : 'Inactive',
            onChanged: (value) {
              if (value != null) widget.onStatusChanged(value);
            },
            isRequired: true,
          )
        else
          Row(
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<PositionStatus>(
                  label: 'Status',
                  value: widget.selectedStatus,
                  items: [PositionStatus.active, PositionStatus.inactive],
                  itemLabelBuilder: (status) => status == PositionStatus.active ? 'Active' : 'Inactive',
                  onChanged: (value) {
                    if (value != null) widget.onStatusChanged(value);
                  },
                  isRequired: true,
                ),
              ),
              Gap(24.w),
              const Expanded(child: Gap(0)),
            ],
          ),
      ],
    );
  }
}
