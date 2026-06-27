import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/editable_work_pattern_days_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditWorkPatternMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkPattern workPattern;

  const EditWorkPatternMobileSheet({super.key, required this.enterpriseId, required this.workPattern});

  static Future<void> show(BuildContext context, int enterpriseId, WorkPattern workPattern) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Edit Work Pattern',
      barrierDismissible: false,
      child: EditWorkPatternMobileSheet(enterpriseId: enterpriseId, workPattern: workPattern),
    );
  }

  @override
  ConsumerState<EditWorkPatternMobileSheet> createState() => _EditWorkPatternMobileSheetState();
}

class _EditWorkPatternMobileSheetState extends ConsumerState<EditWorkPatternMobileSheet> {
  late final TextEditingController _patternCodeController;
  late final TextEditingController _patternNameEnController;
  late final TextEditingController _patternNameArController;
  late final TextEditingController _totalHoursController;

  late PositionStatus _selectedStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final p = widget.workPattern;
    _patternCodeController = TextEditingController(text: p.patternCode);
    _patternNameEnController = TextEditingController(text: p.patternNameEn);
    _patternNameArController = TextEditingController(text: p.patternNameAr);
    _totalHoursController = TextEditingController(text: p.totalHoursPerWeek.toString());
    _selectedStatus = p.status;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(workPatternTypeProvider(widget.enterpriseId).notifier).setSelectedCode(p.patternType);
      ref.read(workPatternDaysProvider(widget.enterpriseId).notifier).initializeFromDays(p.days);
      _recalculateTotalHours();
    });
  }

  @override
  void dispose() {
    _patternCodeController.dispose();
    _patternNameEnController.dispose();
    _patternNameArController.dispose();
    _totalHoursController.dispose();
    super.dispose();
  }

  void _recalculateTotalHours() {
    final daysState = ref.read(workPatternDaysProvider(widget.enterpriseId));
    _totalHoursController.text = (daysState.workingDays.length * 8).toString();
  }

  void _toggleWorkingDay(int dayNumber) {
    setState(() {
      final patternTypeView = ref.read(workPatternTypeViewProvider(widget.enterpriseId));
      final requiredWorkingDays = patternTypeView.requiredWorkingDays;
      final daysState = ref.read(workPatternDaysProvider(widget.enterpriseId));
      final daysNotifier = ref.read(workPatternDaysProvider(widget.enterpriseId).notifier);

      if (patternTypeView.selected == null) {
        ToastService.error(context, 'Please select a pattern type first', title: 'Validation Error');
        return;
      }

      if (daysState.workingDays.contains(dayNumber)) {
        daysNotifier.toggleWorkingDay(dayNumber);
      } else {
        if (requiredWorkingDays != null &&
            requiredWorkingDays > 0 &&
            daysState.workingDays.length >= requiredWorkingDays) {
          ToastService.error(
            context,
            'You can select only $requiredWorkingDays working days for this pattern type',
            title: 'Validation Error',
          );
          return;
        }
        daysNotifier.toggleWorkingDay(dayNumber);
      }
      _recalculateTotalHours();
    });
  }

  void _toggleRestDay(int dayNumber) {
    setState(() {
      final patternTypeState = ref.read(workPatternTypeProvider(widget.enterpriseId));
      if (patternTypeState.selectedCode == null || patternTypeState.selectedCode!.isEmpty) {
        ToastService.error(context, 'Please select a pattern type first', title: 'Validation Error');
        return;
      }
      ref.read(workPatternDaysProvider(widget.enterpriseId).notifier).toggleRestDay(dayNumber);
      _recalculateTotalHours();
    });
  }

  void _toggleOffDay(int dayNumber) {
    setState(() {
      final patternTypeState = ref.read(workPatternTypeProvider(widget.enterpriseId));
      if (patternTypeState.selectedCode == null || patternTypeState.selectedCode!.isEmpty) {
        ToastService.error(context, 'Please select a pattern type first', title: 'Validation Error');
        return;
      }
      ref.read(workPatternDaysProvider(widget.enterpriseId).notifier).toggleOffDay(dayNumber);
      _recalculateTotalHours();
    });
  }

  Future<void> _handleUpdate() async {
    final patternTypeState = ref.read(workPatternTypeProvider(widget.enterpriseId));
    final selectedPatternType = patternTypeState.selectedCode;

    final notifier = ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier);
    final totalHours = int.tryParse(_totalHoursController.text) ?? 0;
    final validationError = notifier.validateUpdateInputs(
      patternNameEn: _patternNameEnController.text,
      patternNameAr: _patternNameArController.text.isEmpty ? null : _patternNameArController.text,
      patternType: selectedPatternType,
      totalHoursPerWeek: totalHours,
    );

    if (validationError != null) {
      if (!mounted) return;
      ToastService.error(context, validationError, title: 'Validation Error');
      return;
    }

    final daysState = ref.read(workPatternDaysProvider(widget.enterpriseId));

    if (daysState.workingDays.isEmpty) {
      if (!mounted) return;
      ToastService.error(context, 'Please select at least one working day', title: 'Validation Error');
      return;
    }

    final patternTypeView = ref.read(workPatternTypeViewProvider(widget.enterpriseId));
    final requiredWorkingDays = patternTypeView.requiredWorkingDays;
    if (requiredWorkingDays != null && requiredWorkingDays > 0 && daysState.workingDays.length != requiredWorkingDays) {
      if (!mounted) return;
      ToastService.error(
        context,
        'Please select exactly $requiredWorkingDays working days for this pattern type',
        title: 'Validation Error',
      );
      return;
    }

    final totalSelectedDays = daysState.workingDays.length + daysState.restDays.length + daysState.offDays.length;
    if (totalSelectedDays != 7) {
      if (!mounted) return;
      ToastService.error(
        context,
        'Please assign each day of the week as Working, Rest, or Off',
        title: 'Validation Error',
      );
      return;
    }

    final days = <WorkPatternDay>[];
    for (int i = 1; i <= 7; i++) {
      if (daysState.workingDays.contains(i)) {
        days.add(WorkPatternDay(dayOfWeek: i, dayType: 'WORK'));
      } else if (daysState.restDays.contains(i)) {
        days.add(WorkPatternDay(dayOfWeek: i, dayType: 'REST'));
      } else if (daysState.offDays.contains(i)) {
        days.add(WorkPatternDay(dayOfWeek: i, dayType: 'OFF'));
      }
    }

    setState(() => _isUpdating = true);

    try {
      await notifier.updateWorkPattern(
        workPatternId: widget.workPattern.workPatternId,
        patternNameEn: _patternNameEnController.text.trim(),
        patternNameAr: _patternNameArController.text.trim(),
        patternType: selectedPatternType!,
        totalHoursPerWeek: int.tryParse(_totalHoursController.text) ?? 40,
        status: _selectedStatus,
        days: days,
      );
      if (mounted) {
        Navigator.of(context).pop();
        ToastService.success(context, 'Work pattern updated successfully', title: 'Success');
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Failed to update work pattern: ${e.toString()}', title: 'Error');
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final patternTypeView = ref.watch(workPatternTypeViewProvider(widget.enterpriseId));
    final daysState = ref.watch(workPatternDaysProvider(widget.enterpriseId));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField(
                  controller: _patternCodeController,
                  labelText: 'Pattern Code',
                  isRequired: true,
                  readOnly: true,
                  enabled: false,
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: _patternNameEnController,
                  labelText: 'Pattern Name (English)',
                  hintText: 'e.g., Standard 5-Day Week',
                  isRequired: true,
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: _patternNameArController,
                  labelText: 'Pattern Name (Arabic)',
                  hintText: 'Enter pattern name in Arabic (Optional)',
                  isRequired: false,
                  inputFormatters: [AppInputFormatters.nameAny],
                ),
                Gap(16.h),
                DigifySelectFieldWithLabel<EmplLookupValue>(
                  label: 'Pattern Type',
                  hint: patternTypeView.isLoading ? localizations.pleaseWait : localizations.selectType,
                  value: patternTypeView.selected,
                  items: patternTypeView.items,
                  itemLabelBuilder: (v) => v.meaningEn,
                  onChanged: patternTypeView.isLoading
                      ? null
                      : (value) {
                          ref
                              .read(workPatternTypeProvider(widget.enterpriseId).notifier)
                              .setSelectedCode(value?.lookupCode);
                        },
                  isRequired: true,
                ),
                Gap(16.h),
                Row(
                  children: [
                    Expanded(
                      child: DigifyTextField(
                        controller: _totalHoursController,
                        labelText: 'Total Hours/Week',
                        hintText: '40',
                        isRequired: true,
                        readOnly: true,
                        enabled: false,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: DigifySelectFieldWithLabel<PositionStatus>(
                        label: 'Status',
                        value: _selectedStatus,
                        items: [PositionStatus.active, PositionStatus.inactive],
                        itemLabelBuilder: (s) => s == PositionStatus.active ? 'Active' : 'Inactive',
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedStatus = value);
                        },
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Gap(20.h),
                EditableWorkPatternDaysSection(
                  label: 'Working Days',
                  isDark: isDark,
                  selectedDays: daysState.workingDays,
                  onDayToggle: _toggleWorkingDay,
                  isRequired: true,
                  compact: true,
                ),
                Gap(16.h),
                EditableWorkPatternDaysSection(
                  label: 'Rest Days',
                  isDark: isDark,
                  selectedDays: daysState.restDays,
                  onDayToggle: _toggleRestDay,
                  isRequired: false,
                  compact: true,
                ),
                Gap(16.h),
                EditableWorkPatternDaysSection(
                  label: 'Off Days',
                  isDark: isDark,
                  selectedDays: daysState.offDays,
                  onDayToggle: _toggleOffDay,
                  isRequired: false,
                  compact: true,
                ),
              ],
            ),
          ),
        ),
        WorkPatternSheetFooter(
          cancelLabel: 'Cancel',
          actionLabel: 'Save Changes',
          actionIcon: Assets.icons.saveIcon.path,
          isLoading: _isUpdating,
          onCancel: _isUpdating ? null : () => Navigator.of(context).pop(),
          onAction: _isUpdating ? null : _handleUpdate,
        ),
      ],
    );
  }
}
