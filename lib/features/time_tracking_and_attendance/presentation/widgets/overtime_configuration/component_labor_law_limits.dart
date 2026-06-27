import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/overtime_configuration/overtime_configuration_provider.dart';

class ComponentLaborLawLimit extends ConsumerStatefulWidget {
  const ComponentLaborLawLimit({super.key});

  @override
  ConsumerState<ComponentLaborLawLimit> createState() =>
      _ComponentLaborLawLimitState();
}

class _ComponentLaborLawLimitState
    extends ConsumerState<ComponentLaborLawLimit> {
  final _maxDailyOvertimeController = TextEditingController();
  final _maxAnnualOvertimeController = TextEditingController();
  final _minRestPeriodController = TextEditingController();
  final _lawReferenceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _maxDailyOvertimeController.text = '';
    _maxAnnualOvertimeController.text = '';
    _minRestPeriodController.text = '';
    _lawReferenceController.text = '';
    _notesController.text = '';
  }

  @override
  void dispose() {
    _maxDailyOvertimeController.dispose();
    _maxAnnualOvertimeController.dispose();
    _minRestPeriodController.dispose();
    _lawReferenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final laborLawLimits = ref.watch(
      overtimeConfigurationProvider.select((state) => state.laborLawLimits),
    );
    final notifier = ref.read(overtimeConfigurationProvider.notifier);

    final maxDailyOvertime = laborLawLimits?.maxDailyOvertime ?? "";
    if (_maxDailyOvertimeController.text != maxDailyOvertime) {
      _maxDailyOvertimeController.text = maxDailyOvertime;
    }

    final maxAnnualOvertime = laborLawLimits?.maxAnnualOvertime ?? "";
    if (_maxAnnualOvertimeController.text != maxAnnualOvertime) {
      _maxAnnualOvertimeController.text = maxAnnualOvertime;
    }

    final minRestPeriod = laborLawLimits?.minRestPeriod ?? "";
    if (_minRestPeriodController.text != minRestPeriod) {
      _minRestPeriodController.text = minRestPeriod;
    }

    final lawReference = laborLawLimits?.lawReference ?? "";
    if (_lawReferenceController.text != lawReference) {
      _lawReferenceController.text = lawReference;
    }

    final notes = laborLawLimits?.notes ?? "";
    if (_notesController.text != notes) {
      _notesController.text = notes;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.attendanceMainIcon.path,
                color: AppColors.primary,
                height: 28.h,
                width: 28.w,
              ),
              Gap(8.w),
              Text(
                'Labor Law Limits',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(24.h),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Max Daily Overtime (Hours)',
                    hintText: "e.g. 2",
                    controller: _maxDailyOvertimeController,
                    onChanged: (value) =>
                        notifier.updateLaborLawLimitsMaxDailyOvertime(value),
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Law recommendation: 2 hours per day',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Max Annual Overtime (Hours)',
                    hintText: "e.g. 180",
                    controller: _maxAnnualOvertimeController,
                    onChanged: (value) =>
                        notifier.updateLaborLawLimitsMaxAnnualOvertime(value),
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Statutory limit: 180 hours per year',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Min Rest Period (Hours)',
                    hintText: "e.g. 11",
                    controller: _minRestPeriodController,
                    onChanged: (value) =>
                        notifier.updateLaborLawLimitsMinRestPeriod(value),
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Standard: 11 hours between shifts',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              DigifyTextField(
                labelText: 'Law Reference',
                hintText: "e.g. Section 123, Labor Law",
                controller: _lawReferenceController,
                onChanged: (value) =>
                    notifier.updateLaborLawLimitsLawReference(value),
              ),
              Gap(16.h),
              DigifyTextArea(
                labelText: 'Notes',
                hintText: "Write...",
                controller: _notesController,
                onChanged: (value) => notifier.updateLaborLawLimitsNotes(value),
              ),
            ],
          ),
          DigifyDivider(height: 48.h),
        ],
      ),
    );
  }
}
