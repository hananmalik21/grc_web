import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart'; // ComponentStatus
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_filter_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_lookups_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentsFilterBar extends ConsumerStatefulWidget {
  const ComponentsFilterBar({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<ComponentsFilterBar> createState() => _ComponentsFilterBarState();
}

class _ComponentsFilterBarState extends ConsumerState<ComponentsFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final filterState = ref.watch(componentsFilterProvider);
    final filterNotifier = ref.read(componentsFilterProvider.notifier);

    final categoriesAsync = ref.watch(componentCategoryLookupProvider);
    final calculationMethodsAsync = ref.watch(componentCalculationMethodLookupProvider);

    return Container(
      padding: EdgeInsets.all(16.r),
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
            hintText: 'Search components by name, code, or category...',
            onChanged: filterNotifier.setSearch,
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
                child: categoriesAsync.when(
                  data: (categories) => DigifySelectField<String?>(
                    hint: 'All Categories',
                    value: filterState.category,
                    items: [null, ...categories.map((e) => e.valueCode)],
                    itemLabelBuilder: (code) =>
                        code == null ? 'All Categories' : categories.firstWhere((e) => e.valueCode == code).valueName,
                    onChanged: filterNotifier.setCategory,
                  ),
                  loading: () =>
                      DigifySelectField<String>(hint: 'All Categories', items: const [], itemLabelBuilder: (v) => v),
                  error: (_, _) =>
                      DigifySelectField<String>(hint: 'All Categories', items: const [], itemLabelBuilder: (v) => v),
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<ComponentStatus?>(
                  hint: 'All Statuses',
                  value: filterState.status,
                  items: [null, ...ComponentStatus.values],
                  itemLabelBuilder: (status) => status == null ? 'All Statuses' : status.label,
                  onChanged: filterNotifier.setStatus,
                ),
              ),
              SizedBox(
                width: 220.w,
                child: calculationMethodsAsync.when(
                  data: (methods) => DigifySelectField<String?>(
                    hint: 'All Calculations',
                    value: filterState.calculationMethod,
                    items: [null, ...methods.map((e) => e.valueCode)],
                    itemLabelBuilder: (code) =>
                        code == null ? 'All Calculations' : methods.firstWhere((e) => e.valueCode == code).valueName,
                    onChanged: filterNotifier.setCalculationMethod,
                  ),
                  loading: () =>
                      DigifySelectField<String>(hint: 'All Calculations', items: const [], itemLabelBuilder: (v) => v),
                  error: (_, _) =>
                      DigifySelectField<String>(hint: 'All Calculations', items: const [], itemLabelBuilder: (v) => v),
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
