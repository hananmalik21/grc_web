import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _showDutyRoleFiltersProvider = StateProvider.autoDispose<bool>((ref) => false);

class DutyRolesSearchCardMobile extends ConsumerStatefulWidget {
  const DutyRolesSearchCardMobile({super.key});

  @override
  ConsumerState<DutyRolesSearchCardMobile> createState() => _DutyRolesSearchCardMobileState();
}

class _DutyRolesSearchCardMobileState extends ConsumerState<DutyRolesSearchCardMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(dutyRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dutyRolesProvider);
    final notifier = ref.read(dutyRolesProvider.notifier);
    final hint = state.categoriesLoading ? 'Loading categories…' : 'All Categories';
    final showFilters = ref.watch(_showDutyRoleFiltersProvider);
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
                    hintText: 'Search duty roles...',
                    filled: true,
                    fillColor: Colors.transparent,
                    onChanged: notifier.updateSearch,
                  ),
                ),
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.employeeManagement.filterMain.path,
                  type: AppButtonType.outline,
                  onPressed: () => ref.read(_showDutyRoleFiltersProvider.notifier).state = !showFilters,
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
                          'Filters',
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            notifier.updateSearch('');
                            notifier.updateCategory(null);
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
                    DigifySelectFieldWithLabel<SecurityLookupValue?>(
                      label: 'Category',
                      value: state.selectedCategoryLookup,
                      items: [null, ...state.categoryLookups],
                      itemLabelBuilder: (item) => item?.valueName ?? 'All Categories',
                      hint: hint,
                      onChanged: state.categoriesLoading ? null : (v) => notifier.updateCategory(v?.valueCode),
                      fillColor: Colors.transparent,
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
