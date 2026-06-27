import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/employee_management/application/employee_detail_compensation/providers/employee_detail_assigned_components_providers.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/edit_employee_assigned_components_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailAssignedComponentsSection extends ConsumerWidget {
  const EmployeeDetailAssignedComponentsSection({super.key, required this.employeeGuid, required this.isDark});

  final String employeeGuid;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final stateAsync = ref.watch(employeeDetailAssignedComponentsProvider(employeeGuid));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.compensation.components.path,
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    localizations.editEmployeeAssignedComponentsTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: stateAsync.when(
              loading: () => EmployeeAssignedComponentsContent(
                componentsAsync: const AsyncLoading(),
                onRetry: () => ref.invalidate(employeeDetailAssignedComponentsProvider(employeeGuid)),
                isDark: isDark,
                localizations: localizations,
              ),
              error: (error, stackTrace) => EmployeeAssignedComponentsContent(
                componentsAsync: AsyncError(error, stackTrace),
                onRetry: () => ref.invalidate(employeeDetailAssignedComponentsProvider(employeeGuid)),
                isDark: isDark,
                localizations: localizations,
              ),
              data: (state) => EmployeeAssignedComponentsContent(
                componentsAsync: AsyncData(state.components),
                onRetry: () => ref.invalidate(employeeDetailAssignedComponentsProvider(employeeGuid)),
                isDark: isDark,
                localizations: localizations,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
