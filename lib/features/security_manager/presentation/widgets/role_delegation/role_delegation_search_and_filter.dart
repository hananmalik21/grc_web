import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RoleDelegationSearchAndFilter extends StatelessWidget {
  final TextEditingController searchController;
  final RoleDelegationStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RoleDelegationStatus?> onStatusFilterChanged;
  final bool isDark;

  const RoleDelegationSearchAndFilter({
    super.key,
    required this.searchController,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField.search(
                  controller: searchController,
                  hintText: 'Search by delegator, delegate, reason, or ID...',
                  fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                  onChanged: onSearchChanged,
                ),
                Gap(12.h),
                SizedBox(
                  width: double.infinity,
                  child: DigifySelectField<RoleDelegationStatus?>(
                    hint: 'All Status',
                    value: statusFilter,
                    items: roleDelegationStatusFilterItems,
                    itemLabelBuilder: (item) => item == null ? 'All Status' : item.label,
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    onChanged: onStatusFilterChanged,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: searchController,
                    hintText: 'Search by delegator, delegate, reason, or ID...',
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    onChanged: onSearchChanged,
                  ),
                ),
                Gap(16.w),
                SizedBox(
                  width: 200.w,
                  child: DigifySelectField<RoleDelegationStatus?>(
                    hint: 'All Status',
                    value: statusFilter,
                    items: roleDelegationStatusFilterItems,
                    itemLabelBuilder: (item) => item == null ? 'All Status' : item.label,
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    onChanged: onStatusFilterChanged,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
