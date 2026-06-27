import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryStructureCreationStepper extends StatelessWidget {
  final int currentStep;

  const SalaryStructureCreationStepper({super.key, required this.currentStep});

  static final _steps = <_SalaryStructureStepMeta>[
    _SalaryStructureStepMeta(label: 'Basic Information', iconPath: Assets.icons.registrationCardIcon.path),
    _SalaryStructureStepMeta(label: 'Scope & Assignment', iconPath: Assets.icons.buildingSmallIcon.path),
    _SalaryStructureStepMeta(label: 'Components', iconPath: Assets.icons.compensation.box.path),
    _SalaryStructureStepMeta(label: 'Financial Details', iconPath: Assets.icons.budgetIcon.path),
    _SalaryStructureStepMeta(label: 'Advanced Settings', iconPath: Assets.icons.manageEnterpriseIcon.path),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final stepCount = _steps.length;
    final progressFraction = stepCount == 0 ? 0.0 : ((currentStep + 1).clamp(0, stepCount) / stepCount).toDouble();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = (constraints.maxWidth * progressFraction).clamp(0.0, constraints.maxWidth);

          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  width: fillWidth,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100.r)),
                ),
              ),
              Row(
                children: _steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isSelected = currentStep == index;
                  final isCompleted = index < currentStep;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _SalaryStructureStepChip(
                        label: step.label,
                        iconPath: step.iconPath,
                        isSelected: isSelected,
                        isCompleted: isCompleted,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SalaryStructureStepChip extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final bool isCompleted;

  const _SalaryStructureStepChip({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fg = (isSelected || isCompleted)
        ? Colors.white
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DigifyAsset(assetPath: iconPath, width: 16.w, height: 16.w, color: fg),
          Gap(8.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(
                color: fg,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryStructureStepMeta {
  final String label;
  final String iconPath;

  const _SalaryStructureStepMeta({required this.label, required this.iconPath});
}
