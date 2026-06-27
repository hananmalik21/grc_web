import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/demographics_dropdown.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DemographicsModule extends ConsumerWidget {
  const DemographicsModule({super.key, this.demographicsStepOnly = false});

  final bool demographicsStepOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final demographics = ref.watch(addEmployeeDemographicsProvider);
    final demographicsNotifier = ref.read(addEmployeeDemographicsProvider.notifier);
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);

    if (enterpriseId == null) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Text(
          localizations.demographics,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      );
    }

    final typesAsync = demographicsStepOnly
        ? ref.watch(emplLookupTypesForDemographicsStepProvider(enterpriseId))
        : ref.watch(emplLookupTypesProvider(enterpriseId));
    final orderedTypes = typesAsync.valueOrNull ?? [];
    final isLoadingTypes = typesAsync.isLoading;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: em.demographics.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.demographics,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          if (isLoadingTypes)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLoadingIndicator(
                      type: LoadingType.circle,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                      size: 32.r,
                    ),
                    Gap(12.h),
                    Text(
                      localizations.pleaseWait,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth > 500;
                final fields = orderedTypes
                    .map(
                      (type) => DemographicsDropdown(
                        type: type,
                        enterpriseId: enterpriseId,
                        demographics: demographics,
                        demographicsNotifier: demographicsNotifier,
                      ),
                    )
                    .toList();
                if (fields.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (useTwoColumns) {
                  final rows = <Widget>[];
                  for (var i = 0; i < fields.length; i += 2) {
                    rows.add(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: fields[i]),
                          if (i + 1 < fields.length) ...[Gap(14.w), Expanded(child: fields[i + 1])],
                        ],
                      ),
                    );
                    if (i + 2 < fields.length) {
                      rows.add(Gap(16.h));
                    }
                  }
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
                }
                return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 16.h, children: fields);
              },
            ),
        ],
      ),
    );
  }
}
