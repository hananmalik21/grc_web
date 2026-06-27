import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_filter_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_filter_dropdowns.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionsFilterBarMobile extends ConsumerStatefulWidget {
  const RequisitionsFilterBarMobile({super.key});

  @override
  ConsumerState<RequisitionsFilterBarMobile> createState() => _RequisitionsFilterBarMobileState();
}

class _RequisitionsFilterBarMobileState extends ConsumerState<RequisitionsFilterBarMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final showFilters = ref.watch(requisitionsShowFiltersProvider);
    final filterNotifier = ref.read(requisitionsFilterProvider.notifier);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: loc.hiringRequisitionsSearchHintMobile,
                  onChanged: filterNotifier.setSearch,
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                type: AppButtonType.outline,
                onPressed: () => ref.read(requisitionsShowFiltersProvider.notifier).state = !showFilters,
                backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                borderColor: showFilters ? AppColors.primary : null,
                foregroundColor: showFilters
                    ? AppColors.primary
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
            ],
          ),
          if (showFilters) ...[
            Gap(12.h),
            _RequisitionsFiltersPanelMobile(
              isDark: isDark,
              onClearAll: () {
                _searchController.clear();
                filterNotifier.reset();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _RequisitionsFiltersPanelMobile extends ConsumerWidget {
  const _RequisitionsFiltersPanelMobile({required this.isDark, required this.onClearAll});

  final bool isDark;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 16, height: 16),
                  Gap(6.w),
                  Text(
                    loc.advancedFilters,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onClearAll,
                child: Text(
                  loc.clearAll,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Gap(12.h),
          const RequisitionsFilterDropdowns(stackVertically: true, runSpacing: 8),
        ],
      ),
    );
  }
}
