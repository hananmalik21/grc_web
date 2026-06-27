import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../providers/compensation_plans/compensation_plans_table_rows_provider.dart';

class CompensationPlansFilterBar extends ConsumerStatefulWidget {
  const CompensationPlansFilterBar({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<CompensationPlansFilterBar> createState() => _CompensationPlansFilterBarState();
}

class _CompensationPlansFilterBarState extends ConsumerState<CompensationPlansFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(compensationPlansSearchFilterProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _labelForCode(List<CompensationPlansFilterOption> options, String code) {
    for (final option in options) {
      if (option.code == code) {
        return option.label;
      }
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final selectedPlanTypeCode =
        ref.watch(compensationPlansPlanTypeCodeFilterProvider) ?? compensationPlansAllPlanTypesCode;
    final selectedCurrencyCode =
        ref.watch(compensationPlansCurrencyCodeFilterProvider) ?? compensationPlansAllCurrencyCode;
    final selectedStatus = ref.watch(compensationPlansStatusFilterProvider);
    final planTypeOptions = ref.watch(compensationPlansPlanTypeFilterOptionsProvider);
    final currencyOptions = ref.watch(compensationPlansCurrencyFilterOptionsProvider);

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
            hintText: 'Search plans by name, code, or type...',
            onChanged: (value) => ref.read(compensationPlansFiltersControllerProvider.notifier).onSearchChanged(value),
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
                  hint: 'Type',
                  value: selectedPlanTypeCode,
                  items: planTypeOptions.map((option) => option.code).toList(),
                  itemLabelBuilder: (item) => _labelForCode(planTypeOptions, item),
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(compensationPlansFiltersControllerProvider.notifier)
                        .onPlanTypeCodeChanged(value == compensationPlansAllPlanTypesCode ? null : value);
                  },
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Currency',
                  value: selectedCurrencyCode,
                  items: currencyOptions.map((option) => option.code).toList(),
                  itemLabelBuilder: (item) => _labelForCode(currencyOptions, item),
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(compensationPlansFiltersControllerProvider.notifier)
                        .onCurrencyCodeChanged(value == compensationPlansAllCurrencyCode ? null : value);
                  },
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<SalaryStructureStatus?>(
                  hint: 'Status',
                  value: selectedStatus,
                  items: [null, ...SalaryStructureStatus.values],
                  itemLabelBuilder: (item) => item?.label ?? 'All Status',
                  onChanged: (value) {
                    ref.read(compensationPlansFiltersControllerProvider.notifier).onStatusChanged(value);
                  },
                ),
              ),
              AppButton(
                label: 'Export',
                onPressed: widget.isExporting ? null : widget.onExport,
                isLoading: widget.isExporting,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
