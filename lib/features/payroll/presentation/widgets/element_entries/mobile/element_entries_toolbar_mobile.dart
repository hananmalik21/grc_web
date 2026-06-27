import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesToolbarMobile extends ConsumerWidget {
  const ElementEntriesToolbarMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final uiState = ref.watch(elementEntriesUiProvider);
    final uiNotifier = ref.read(elementEntriesUiProvider.notifier);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10.r)),
                child: Icon(Icons.tune_outlined, color: AppColors.primary, size: 18.sp),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Element Entries',
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      'Earnings, deductions & payroll elements',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          DigifyDateField(
            label: 'Effective Date',
            isRequired: false,
            initialDate: uiState.effectiveDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateSelected: uiNotifier.setEffectiveDate,
          ),
        ],
      ),
    );
  }
}
