import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/applications/controllers/applications_controller.dart';
import 'package:grc/features/hiring/application/applications/states/applications_state.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_lookups_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationsFilterBarMobile extends ConsumerStatefulWidget {
  const ApplicationsFilterBarMobile({super.key});

  @override
  ConsumerState<ApplicationsFilterBarMobile> createState() => _ApplicationsFilterBarMobileState();
}

class _ApplicationsFilterBarMobileState extends ConsumerState<ApplicationsFilterBarMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(applicationsControllerProvider);
    final controller = ref.read(applicationsControllerProvider.notifier);

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
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: 'Search applications...',
                  onChanged: controller.setSearch,
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                type: AppButtonType.outline,
                onPressed: controller.toggleFilters,
                backgroundColor: state.showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                borderColor: state.showFilters ? AppColors.primary : null,
                foregroundColor: state.showFilters
                    ? AppColors.primary
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
            ],
          ),
          if (state.showFilters) ...[
            Gap(12.h),
            _FiltersPanel(
              isDark: isDark,
              state: state,
              controller: controller,
              onClearAll: () {
                _searchController.clear();
                controller.resetFilters();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({required this.isDark, required this.state, required this.controller, required this.onClearAll});

  final bool isDark;
  final ApplicationsState state;
  final ApplicationsNotifier controller;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statuses = ref.watch(applicationStatusLookupProvider);
    final sources = ref.watch(applicationSourceLookupProvider);

    return Container(
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
                    'Filters',
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
                  'Clear All',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Gap(12.h),
          DigifySelectField<String?>(
            hint: 'Status',
            value: state.status,
            items: [null, ...statuses],
            itemLabelBuilder: (status) => status ?? 'All Statuses',
            onChanged: controller.setStatus,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifySelectField<String?>(
            hint: 'Source',
            value: state.source,
            items: [null, ...sources],
            itemLabelBuilder: (source) => source ?? 'All Sources',
            onChanged: controller.setSource,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
