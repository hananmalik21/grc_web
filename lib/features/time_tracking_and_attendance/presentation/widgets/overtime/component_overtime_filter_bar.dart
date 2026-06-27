import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/overtime/overtime_provider.dart';
import '../../../../../core/services/responsive/responsive_extensions.dart';

class ComponentOvertimeFilterBar extends ConsumerWidget {
  const ComponentOvertimeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overtimeManagementProvider);
    final notifier = ref.read(overtimeManagementProvider.notifier);
    final isDark = context.isDark;
    final isMobile = context.isMobile;

    Widget categoriesList = SizedBox(
      height: 35.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final category = state.categories![index];
          final isSelected = state.selectedCategory == category;

          return Material(
            color: isSelected
                ? (isDark ? context.colorScheme.primary : AppColors.primary)
                : (isDark ? AppColors.backgroundDark : AppColors.grayBg),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: () => notifier.selectCategory(category),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Gap(7.w),
        itemCount: state.categories?.length ?? 0,
      ),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.usersIcon.path,
                      width: 20,
                      height: 20,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    Gap(10.w),
                    Text(
                      'Categories',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Gap(12.h),
                categoriesList,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.usersIcon.path,
                  width: 20,
                  height: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                Gap(14.w),
                Expanded(child: categoriesList),
              ],
            ),
    );
  }
}
