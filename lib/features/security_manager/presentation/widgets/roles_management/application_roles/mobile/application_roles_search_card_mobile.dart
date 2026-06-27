import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _showFiltersProvider = StateProvider.autoDispose<bool>((ref) => false);

class ApplicationRolesSearchCardMobile extends ConsumerStatefulWidget {
  const ApplicationRolesSearchCardMobile({super.key});

  @override
  ConsumerState<ApplicationRolesSearchCardMobile> createState() => _ApplicationRolesSearchCardMobileState();
}

class _ApplicationRolesSearchCardMobileState extends ConsumerState<ApplicationRolesSearchCardMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(applicationRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationRolesProvider);
    final notifier = ref.read(applicationRolesProvider.notifier);
    final showFilters = ref.watch(_showFiltersProvider);
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: _searchController,
                    hintText: 'Search roles...',
                    filled: true,
                    fillColor: Colors.transparent,
                    onChanged: (value) => notifier.setSearchQuery(value),
                  ),
                ),
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.employeeManagement.filterMain.path,
                  type: AppButtonType.outline,
                  onPressed: () => ref.read(_showFiltersProvider.notifier).state = !showFilters,
                  backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                  borderColor: showFilters ? AppColors.primary : null,
                  foregroundColor: showFilters
                      ? AppColors.primary
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                ),
              ],
            ),
            if (showFilters) ...[
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advanced Filters',
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            notifier.setSearchQuery('');
                            notifier.selectTypeFilter(ApplicationRolesNotifier.typeFilterOptions.first);
                            notifier.selectStatusFilter(ApplicationRolesNotifier.statusFilterOptions.first);
                            notifier.selectCategoryFilter(ApplicationRolesNotifier.categoryFilterOptions.first);
                          },
                          child: Text(
                            'Reset',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.brandRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Type',
                      value: state.selectedTypeFilter,
                      items: ApplicationRolesNotifier.typeFilterOptions,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) =>
                          notifier.selectTypeFilter(value ?? ApplicationRolesNotifier.typeFilterOptions.first),
                    ),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Status',
                      value: state.selectedStatusFilter,
                      items: ApplicationRolesNotifier.statusFilterOptions,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) =>
                          notifier.selectStatusFilter(value ?? ApplicationRolesNotifier.statusFilterOptions.first),
                    ),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Category',
                      value: state.selectedCategoryFilter,
                      items: ApplicationRolesNotifier.categoryFilterOptions,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) =>
                          notifier.selectCategoryFilter(value ?? ApplicationRolesNotifier.categoryFilterOptions.first),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
