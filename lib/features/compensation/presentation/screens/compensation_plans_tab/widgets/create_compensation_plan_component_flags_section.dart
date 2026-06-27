import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateCompensationPlanComponentFlagsSection extends StatelessWidget {
  const CreateCompensationPlanComponentFlagsSection({required this.settings, required this.onChanged, super.key});

  final CreateCompensationPlanComponentSettings settings;
  final void Function({
    bool? recurring,
    bool? optional,
    bool? isActive,
    bool? pensionable,
    bool? statutory,
    bool? includeInCtc,
    bool? prorated,
    bool? taxable,
    bool? amortizable,
  })
  onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final flags = [
      (label: 'Recurring', value: settings.recurring, setter: (bool v) => onChanged(recurring: v)),
      (label: 'Optional', value: settings.optional, setter: (bool v) => onChanged(optional: v)),
      (label: 'Pensionable', value: settings.pensionable, setter: (bool v) => onChanged(pensionable: v)),
      (label: 'Statutory', value: settings.statutory, setter: (bool v) => onChanged(statutory: v)),
      (label: 'Include in CTC', value: settings.includeInCtc, setter: (bool v) => onChanged(includeInCtc: v)),
      (label: 'Prorated', value: settings.prorated, setter: (bool v) => onChanged(prorated: v)),
      (label: 'Taxable', value: settings.taxable, setter: (bool v) => onChanged(taxable: v)),
      (label: 'Amortizable', value: settings.amortizable, setter: (bool v) => onChanged(amortizable: v)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMPONENT FLAGS',
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: 10.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            letterSpacing: 0.8,
          ),
        ),
        Gap(8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: flags.map((f) => _FlagChip(label: f.label, value: f.value, onChanged: f.setter)).toList(),
        ),
      ],
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: value
              ? (isDark ? AppColors.primary.withValues(alpha: 0.85) : AppColors.primary)
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: value ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
        ),
        child: Text(
          label,
          style: (value ? context.textTheme.labelLarge : context.textTheme.labelSmall)?.copyWith(
            fontSize: 12.sp,
            color: value ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
