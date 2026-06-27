import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/element_entry_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ElementEntriesListMobile extends ConsumerWidget {
  const ElementEntriesListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final uiState = ref.watch(elementEntriesUiProvider);
    final uiNotifier = ref.read(elementEntriesUiProvider.notifier);
    final entries = uiState.entries;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entries.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  'No element entries found',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              itemCount: entries.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) {
                return _ElementEntryCard(
                  row: entries[index],
                  index: index,
                  isDark: isDark,
                  isSelected: uiState.selectedIndices.contains(index),
                  onSelectionChanged: (selected) => uiNotifier.toggleSelection(index, selected),
                );
              },
            ),
          const DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${entries.length} of ${entries.length} entries',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(uiState.effectiveDate),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ElementEntryCard extends StatelessWidget {
  const _ElementEntryCard({
    required this.row,
    required this.index,
    required this.isDark,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  final ElementEntryRow row;
  final int index;
  final bool isDark;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06) : tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Center(
                  child: DigifyCheckbox(value: isSelected, onChanged: (value) => onSelectionChanged(value ?? false)),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.elementName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      'Seq. ${row.seq} · ${row.empNumber}',
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _InfoCell(label: 'Primary Value', value: row.primaryEntryValue, isDark: isDark, monospace: true),
              ),
              Gap(12.w),
              Expanded(
                child: _InfoCell(label: 'Value Name', value: row.valueName, isDark: isDark),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              DigifyCapsule(
                label: row.classification,
                textColor: AppColors.primary,
                backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              ),
              Gap(8.w),
              DigifyCapsule(
                label: row.employmentLevel,
                textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
              ),
            ],
          ),
          Gap(10.h),
          _InfoCell(label: 'Source', value: row.source, isDark: isDark),
          if (row.reason != '—') ...[Gap(8.h), _InfoCell(label: 'Reason', value: row.reason, isDark: isDark)],
          Gap(8.h),
          Row(
            children: [
              Expanded(
                child: _InfoCell(label: 'LDG', value: row.ldg, isDark: isDark),
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.employeeManagement.more.path,
                onTap: () {},
                width: 17.w,
                height: 17.w,
                color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.label, required this.value, required this.isDark, this.monospace = false});

  final String label;
  final String value;
  final bool isDark;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: valueColor,
            fontFamily: monospace ? 'Courier' : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
