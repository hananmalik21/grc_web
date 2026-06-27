import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_config.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_types.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_table_width_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/element_entry_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementEntriesTableRow extends ConsumerWidget {
  const ElementEntriesTableRow({
    required this.row,
    required this.index,
    required this.isDark,
    required this.isSelected,
    super.key,
  });

  final ElementEntryRow row;
  final int index;
  final bool isDark;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(elementEntriesTableWidthsProvider);
    final uiNotifier = ref.read(elementEntriesUiProvider.notifier);

    final textStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark,
    );

    final dividerWidths = <double>[
      ElementEntriesTableConfig.selectWidth.w,
      ...state.columnOrder.map(state.widthFor),
      if (ElementEntriesTableConfig.showActions) ElementEntriesTableConfig.actionsWidth.w,
    ];

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.04) : null,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _buildDivider(dividerWidths[i], isLast: i == dividerWidths.length - 1 || i == 0),
              ],
            ),
          ),
          Row(
            children: [
              _buildDataCell(
                Center(
                  child: DigifyCheckbox(
                    value: isSelected,
                    onChanged: (checked) => uiNotifier.toggleSelection(index, checked ?? false),
                  ),
                ),
                ElementEntriesTableConfig.selectWidth.w,
              ),
              ...state.columnOrder.map((column) {
                final cell = switch (column) {
                  ElementEntriesTableColumn.elementName => Text(
                    row.elementName,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  ElementEntriesTableColumn.primaryEntryValue => Text(
                    row.primaryEntryValue,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  ElementEntriesTableColumn.valueName => Text(
                    row.valueName,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  ElementEntriesTableColumn.source => Text(
                    row.source,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  ElementEntriesTableColumn.employmentLevel => Text(
                    row.employmentLevel,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  ElementEntriesTableColumn.reason => Text(
                    row.reason,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  ElementEntriesTableColumn.classification => Text(
                    row.classification,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  ElementEntriesTableColumn.ldg => Text(row.ldg, overflow: TextOverflow.ellipsis, style: textStyle),
                  ElementEntriesTableColumn.empNumber => Text(
                    row.empNumber,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  ElementEntriesTableColumn.status => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyStatusCapsule(status: row.status),
                  ),
                };

                return _buildDataCell(cell, state.widthFor(column));
              }),
              if (ElementEntriesTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyAssetButton(
                        assetPath: Assets.icons.employeeManagement.more.path,
                        onTap: () {},
                        width: 17.w,
                        height: 17.w,
                        color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      ),
                    ],
                  ),
                  ElementEntriesTableConfig.actionsWidth.w,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.w),
        child: child,
      ),
    );
  }
}
