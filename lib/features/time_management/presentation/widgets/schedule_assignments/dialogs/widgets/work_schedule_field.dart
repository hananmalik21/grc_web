import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/work_schedule_selection_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleField extends StatefulWidget {
  final int? selectedWorkScheduleId;
  final String? selectedWorkScheduleName;
  final int enterpriseId;
  final ValueChanged<WorkSchedule?> onChanged;
  final String? Function(int?)? validator;

  const WorkScheduleField({
    super.key,
    this.selectedWorkScheduleId,
    this.selectedWorkScheduleName,
    required this.enterpriseId,
    required this.onChanged,
    this.validator,
  });

  @override
  State<WorkScheduleField> createState() => _WorkScheduleFieldState();
}

class _WorkScheduleFieldState extends State<WorkScheduleField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedWorkScheduleName ?? '');
  }

  @override
  void didUpdateWidget(WorkScheduleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWorkScheduleName != oldWidget.selectedWorkScheduleName) {
      _controller.text = widget.selectedWorkScheduleName ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Work Schedule',
              style: TextStyle(
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                color: context.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
            Gap(4.w),
            Text(
              '*',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
            ),
          ],
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _controller,
          hintText: 'Select Work Schedule',
          readOnly: true,
          suffixIcon: DigifyAsset(
            assetPath: Assets.icons.workforce.chevronRight.path,
            color: AppColors.textSecondary,
            height: 15,
          ),
          onTap: () async {
            final selectedSchedule = await WorkScheduleSelectionDialog.show(
              context: context,
              enterpriseId: widget.enterpriseId,
              selectedScheduleId: widget.selectedWorkScheduleId,
            );
            if (selectedSchedule != null && context.mounted) {
              _controller.text = selectedSchedule.scheduleNameEn;
              widget.onChanged(selectedSchedule);
            } else if (selectedSchedule == null && context.mounted) {
              widget.onChanged(null);
            }
          },
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(widget.selectedWorkScheduleId);
            }
            if (widget.selectedWorkScheduleId == null) {
              return 'Please select a work schedule';
            }
            return null;
          },
        ),
        Gap(8.h),
        Text(
          'Select an existing work schedule',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: context.isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
