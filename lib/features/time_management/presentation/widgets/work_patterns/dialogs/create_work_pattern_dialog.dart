import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_pattern_create_state.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/editable_work_pattern_days_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateWorkPatternDialog extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateWorkPatternDialog({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    if (ResponsiveHelper.isMobile(context)) {
      return CreateWorkPatternMobileSheet.show(context, enterpriseId);
    }
    return showDialog(
      context: context,
      builder: (context) => CreateWorkPatternDialog(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateWorkPatternDialog> createState() => _CreateWorkPatternDialogState();
}

class _CreateWorkPatternDialogState extends ConsumerState<CreateWorkPatternDialog> {
  final _patternCodeController = TextEditingController();
  final _patternNameEnController = TextEditingController();
  final _patternNameArController = TextEditingController();
  final _totalHoursController = TextEditingController(text: '0');

  PositionStatus _selectedStatus = PositionStatus.active;

  @override
  void dispose() {
    _patternCodeController.dispose();
    _patternNameEnController.dispose();
    _patternNameArController.dispose();
    _totalHoursController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final patternTypeView = ref.read(workPatternTypeViewProvider(widget.enterpriseId));
    final selectedValue = patternTypeView.selected;

    if (selectedValue == null) {
      ToastService.error(context, 'Please select a pattern type');
      return;
    }

    final notifier = ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier);
    final totalHours = int.tryParse(_totalHoursController.text) ?? 0;
    final validationError = notifier.validateCreateInputs(
      patternCode: _patternCodeController.text,
      patternNameEn: _patternNameEnController.text,
      patternNameAr: _patternNameArController.text,
      patternType: selectedValue.lookupCode,
      totalHoursPerWeek: totalHours,
    );

    if (validationError != null) {
      ToastService.error(context, validationError, title: 'Validation Error');
      return;
    }

    final daysState = ref.read(workPatternDaysProvider(widget.enterpriseId));

    final requiredWorkingDays = patternTypeView.requiredWorkingDays;
    if (requiredWorkingDays != null && requiredWorkingDays > 0 && daysState.workingDays.length != requiredWorkingDays) {
      ToastService.error(
        context,
        'Please select exactly $requiredWorkingDays working days for this pattern type',
        title: 'Validation Error',
      );
      return;
    }

    final totalSelectedDays = daysState.workingDays.length + daysState.restDays.length + daysState.offDays.length;
    if (totalSelectedDays != 7) {
      ToastService.error(
        context,
        'Please assign each day of the week as Working, Rest, or Off',
        title: 'Validation Error',
      );
      return;
    }

    // Build days list
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

    try {
      await notifier.createWorkPattern(
        ref,
        patternCode: _patternCodeController.text.trim(),
        patternNameEn: _patternNameEnController.text.trim(),
        patternNameAr: _patternNameArController.text.trim(),
        patternType: selectedValue.lookupCode,
        totalHoursPerWeek: int.tryParse(_totalHoursController.text) ?? 40,
        status: _selectedStatus,
        days: days,
      );

      if (mounted) {
        context.pop();
        ToastService.success(context, 'Work pattern created successfully', title: 'Success');
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Failed to create work pattern: ${e.toString()}', title: 'Error');
      }
    }
  }

  void _toggleWorkingDay(int dayNumber) {
    setState(() {
      final patternTypeView = ref.read(workPatternTypeViewProvider(widget.enterpriseId));
      final selectedValue = patternTypeView.selected;
      final requiredWorkingDays = patternTypeView.requiredWorkingDays;
      final daysState = ref.read(workPatternDaysProvider(widget.enterpriseId));
      final daysNotifier = ref.read(workPatternDaysProvider(widget.enterpriseId).notifier);

      if (selectedValue == null) {
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

      final updatedDays = ref.read(workPatternDaysProvider(widget.enterpriseId));
      final totalHours = updatedDays.workingDays.length * 8;
      _totalHoursController.text = totalHours.toString();
    });
  }

  void _toggleRestDay(int dayNumber) {
    setState(() {
      final patternTypeState = ref.read(workPatternTypeProvider(widget.enterpriseId));
      final selectedPatternType = patternTypeState.selectedCode;
      if (selectedPatternType == null || selectedPatternType.isEmpty) {
        ToastService.error(context, 'Please select a pattern type first', title: 'Validation Error');
        return;
      }

      final daysNotifier = ref.read(workPatternDaysProvider(widget.enterpriseId).notifier);
      daysNotifier.toggleRestDay(dayNumber);

      final updatedDays = ref.read(workPatternDaysProvider(widget.enterpriseId));
      final totalHours = updatedDays.workingDays.length * 8;
      _totalHoursController.text = totalHours.toString();
    });
  }

  void _toggleOffDay(int dayNumber) {
    setState(() {
      final patternTypeState = ref.read(workPatternTypeProvider(widget.enterpriseId));
      final selectedPatternType = patternTypeState.selectedCode;
      if (selectedPatternType == null || selectedPatternType.isEmpty) {
        ToastService.error(context, 'Please select a pattern type first', title: 'Validation Error');
        return;
      }

      final daysNotifier = ref.read(workPatternDaysProvider(widget.enterpriseId).notifier);
      daysNotifier.toggleOffDay(dayNumber);

      final updatedDays = ref.read(workPatternDaysProvider(widget.enterpriseId));
      final totalHours = updatedDays.workingDays.length * 8;
      _totalHoursController.text = totalHours.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final createState = ref.watch(workPatternCreateStateProvider);
    final isCreating = createState.isCreating;
    final localizations = AppLocalizations.of(context)!;
    final patternTypeView = ref.watch(workPatternTypeViewProvider(widget.enterpriseId));

    final daysState = ref.watch(workPatternDaysProvider(widget.enterpriseId));

    return AppDialog(
      title: 'Create New Work Pattern',
      width: 896.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: _patternCodeController,
                  labelText: 'Pattern Code',
                  hintText: 'e.g., STD-5DAY',
                  isRequired: true,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'))],
                ),
              ),
              Gap(24.w),
              Expanded(
                child: DigifyTextField(
                  controller: _patternNameEnController,
                  labelText: 'Pattern Name (English)',
                  hintText: 'e.g., Standard 5-Day Week',
                  isRequired: true,
                ),
              ),
            ],
          ),
          Gap(24.h),

          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: _patternNameArController,
                  labelText: 'Pattern Name (Arabic)',
                  hintText: 'Enter pattern name in Arabic (Optional)',
                  isRequired: false,
                  inputFormatters: [AppInputFormatters.nameAny],
                ),
              ),
              Gap(24.w),
              Expanded(
                child: DigifySelectFieldWithLabel<EmplLookupValue>(
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
                          ref.read(workPatternDaysProvider(widget.enterpriseId).notifier).reset();
                          _totalHoursController.text = '0';
                        },
                  isRequired: true,
                ),
              ),
            ],
          ),
          Gap(24.h),

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
              Gap(24.w),
              Expanded(
                child: DigifySelectFieldWithLabel<PositionStatus>(
                  label: 'Status',
                  value: _selectedStatus,
                  items: [PositionStatus.active, PositionStatus.inactive],
                  itemLabelBuilder: (status) => status == PositionStatus.active ? 'Active' : 'Inactive',
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                  isRequired: true,
                ),
              ),
            ],
          ),
          Gap(24.h),

          EditableWorkPatternDaysSection(
            label: 'Working Days',
            isDark: isDark,
            selectedDays: daysState.workingDays,
            onDayToggle: _toggleWorkingDay,
            isRequired: true,
          ),
          Gap(24.h),

          EditableWorkPatternDaysSection(
            label: 'Rest Days',
            isDark: isDark,
            selectedDays: daysState.restDays,
            onDayToggle: _toggleRestDay,
            isRequired: false,
          ),
          Gap(24.h),

          EditableWorkPatternDaysSection(
            label: 'Off Days',
            isDark: isDark,
            selectedDays: daysState.offDays,
            onDayToggle: _toggleOffDay,
            isRequired: false,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Create Pattern',
          onPressed: isCreating ? null : _handleCreate,
          isLoading: isCreating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
