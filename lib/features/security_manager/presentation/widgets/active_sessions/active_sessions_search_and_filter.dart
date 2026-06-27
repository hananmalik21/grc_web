import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionsSearchAndFilter extends StatelessWidget {
  final TextEditingController searchController;
  final ActiveSessionStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ActiveSessionStatus?> onStatusFilterChanged;
  final bool isDark;

  const ActiveSessionsSearchAndFilter({
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

    final items = <ActiveSessionStatus?>[null, ...ActiveSessionStatus.values];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
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
                  hintText: 'Search by user, location, or IP address...',
                  onChanged: onSearchChanged,
                ),
                Gap(12.h),
                SizedBox(
                  width: double.infinity,
                  child: DigifySelectField<ActiveSessionStatus?>(
                    hint: 'All Statuses',
                    value: statusFilter,
                    items: items,
                    itemLabelBuilder: (item) => item == null ? 'All Statuses' : item.label,
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
                    hintText: 'Search by user, location, or IP address...',
                    onChanged: onSearchChanged,
                  ),
                ),
                Gap(16.w),
                SizedBox(
                  width: 180.w,
                  child: DigifySelectField<ActiveSessionStatus?>(
                    hint: 'All Statuses',
                    value: statusFilter,
                    items: items,
                    itemLabelBuilder: (item) => item == null ? 'All Statuses' : item.label,
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
