import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/user_management_enums.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../data/models/user_management/user_managment_status.dart';
import '../../providers/user_management/user_management_provider.dart';

final _userManagementShowFiltersProvider = StateProvider<bool>((ref) => false);

class UserManagementSearchAndFilterMobile extends ConsumerStatefulWidget {
  const UserManagementSearchAndFilterMobile({super.key});

  @override
  ConsumerState<UserManagementSearchAndFilterMobile> createState() =>
      _UserManagementSearchAndFilterMobileState();
}

class _UserManagementSearchAndFilterMobileState
    extends ConsumerState<UserManagementSearchAndFilterMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(userManagementProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final showFilters = ref.watch(_userManagementShowFiltersProvider);
    final notifier = ref.read(userManagementProvider.notifier);

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
                  hintText: 'Search users...',
                  onChanged: notifier.setSearchQuery,
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () =>
                    ref.read(_userManagementShowFiltersProvider.notifier).state = !showFilters,
              ),
            ],
          ),
          if (showFilters) ...[Gap(12.h), _FiltersPanel(isDark: isDark)],
        ],
      ),
    );
  }
}

class _FilterToggleButton extends StatelessWidget {
  const _FilterToggleButton({
    required this.isDark,
    required this.isActive,
    required this.onTap,
  });

  final bool isDark;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isActive ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.1)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: DigifyAsset(
            assetPath: Assets.icons.employeeManagement.filterMain.path,
            width: 18,
            height: 18,
            color: isActive ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}

class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusFilter = ref.watch(userManagementProvider.select((s) => s.statusFilter));
    final notifier = ref.read(userManagementProvider.notifier);

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
                  DigifyAsset(
                    assetPath: Assets.icons.employeeManagement.filterSecondary.path,
                    width: 16,
                    height: 16,
                  ),
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
                onTap: () => notifier.setStatusFilter(null),
                child: Text(
                  'Clear All',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.brandRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          DigifySelectField<UserManagementStatus?>(
            hint: 'All Status',
            value: statusFilter,
            items: userManagementStatusFilterItems,
            itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
            onChanged: notifier.setStatusFilter,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
