import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_filter_options.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionsFilterDropdowns extends ConsumerWidget {
  const RequisitionsFilterDropdowns({
    super.key,
    this.dropdownWidth,
    this.fillColor,
    this.spacing = 8,
    this.runSpacing = 8,
    this.stackVertically = false,
  });

  final double? dropdownWidth;
  final Color? fillColor;
  final double spacing;
  final double runSpacing;
  final bool stackVertically;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filterState = ref.watch(requisitionsFilterProvider);
    final filterNotifier = ref.read(requisitionsFilterProvider.notifier);
    final effectiveFillColor = fillColor ?? (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);

    Widget buildDropdown({
      required String hint,
      required String? value,
      required List<RequisitionsFilterOption> options,
      required String allLabel,
      required ValueChanged<String?> onChanged,
    }) {
      final field = DigifySelectField<String?>(
        hint: hint,
        value: value,
        items: [null, ...options.map((e) => e.value)],
        itemLabelBuilder: (code) => requisitionsFilterLabelForValue(options, code, allLabel),
        onChanged: onChanged,
        fillColor: effectiveFillColor,
      );

      if (dropdownWidth == null) return field;
      return SizedBox(width: dropdownWidth, child: field);
    }

    final dropdowns = [
      buildDropdown(
        hint: loc.hiringRequisitionsFilterAllDepartments,
        value: filterState.department,
        options: requisitionsDepartmentFilterOptions,
        allLabel: loc.hiringRequisitionsFilterAllDepartments,
        onChanged: filterNotifier.setDepartment,
      ),
      buildDropdown(
        hint: loc.hiringRequisitionsFilterAllPriorities,
        value: filterState.priority,
        options: requisitionsPriorityFilterOptions,
        allLabel: loc.hiringRequisitionsFilterAllPriorities,
        onChanged: filterNotifier.setPriority,
      ),
      buildDropdown(
        hint: loc.hiringRequisitionsFilterAllStatuses,
        value: filterState.status,
        options: requisitionsStatusFilterOptions,
        allLabel: loc.hiringRequisitionsFilterAllStatuses,
        onChanged: filterNotifier.setStatus,
      ),
      buildDropdown(
        hint: loc.hiringRequisitionsFilterAllWorkModes,
        value: filterState.workMode,
        options: requisitionsWorkModeFilterOptions,
        allLabel: loc.hiringRequisitionsFilterAllWorkModes,
        onChanged: filterNotifier.setWorkMode,
      ),
      buildDropdown(
        hint: loc.hiringRequisitionsFilterAllEmploymentTypes,
        value: filterState.employmentType,
        options: requisitionsEmploymentTypeFilterOptions,
        allLabel: loc.hiringRequisitionsFilterAllEmploymentTypes,
        onChanged: filterNotifier.setEmploymentType,
      ),
    ];

    if (stackVertically) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < dropdowns.length; i++) ...[if (i > 0) Gap(runSpacing.h), dropdowns[i]],
        ],
      );
    }

    return Wrap(
      spacing: spacing.w,
      runSpacing: runSpacing.h,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: dropdowns,
    );
  }
}
