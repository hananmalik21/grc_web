import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_list_providers.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustmentsFilterBar extends ConsumerStatefulWidget {
  AdjustmentsFilterBar({AdjustmentsListProviders? providers, super.key})
    : providers = providers ?? adjustmentsListProviders;

  final AdjustmentsListProviders providers;

  @override
  ConsumerState<AdjustmentsFilterBar> createState() => _AdjustmentsFilterBarState();
}

class _AdjustmentsFilterBarState extends ConsumerState<AdjustmentsFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(widget.providers.tabProvider).searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(widget.providers.tabProvider);
    final notifier = ref.read(widget.providers.tabProvider.notifier);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: AdjustmentsTabConfig.searchHint,
            filled: true,
            fillColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            onChanged: notifier.setSearchQuery,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Department',
                  value: state.selectedDepartment,
                  items: notifier.departmentOptions,
                  itemLabelBuilder: (item) => item,
                  fillColor: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
                  onChanged: notifier.setDepartment,
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Region',
                  value: state.selectedRegion,
                  items: notifier.regionOptions,
                  itemLabelBuilder: (item) => item,
                  fillColor: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
                  onChanged: notifier.setRegion,
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Status',
                  value: state.selectedStatus,
                  items: notifier.statusOptions,
                  itemLabelBuilder: (item) => item,
                  fillColor: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
                  onChanged: notifier.setStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
