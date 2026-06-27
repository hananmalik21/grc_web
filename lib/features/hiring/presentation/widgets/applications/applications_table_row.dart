import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';
import '../../screens/application_detail_page.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_table_width_provider.dart';
import 'applications_table_types.dart';

class ApplicationsTableRow extends ConsumerWidget {
  const ApplicationsTableRow({required this.row, required this.isDark, super.key});

  final ApplicationTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationsTableWidthsProvider);
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textMuted;
    final appliedDate = DateFormat.yMMMd().format(row.appliedDate);

    final dividerWidths = <double>[...state.columnOrder.map(state.widthFor)];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _buildDivider(dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...state.columnOrder.map((ApplicationsTableColumn column) {
                final cell = _buildCellForColumn(
                  context,
                  column,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  appliedDate: appliedDate,
                );
                return _buildDataCell(cell, state.widthFor(column));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellForColumn(
    BuildContext context,
    ApplicationsTableColumn column, {
    required Color primaryText,
    required Color secondaryText,
    required String appliedDate,
  }) {
    return switch (column) {
      ApplicationsTableColumn.applicationId => InkWell(
        onTap: () => context.pushNamed(ApplicationDetailPage.routeName, extra: row),
        child: Text(
          row.applicationId,
          style: context.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ),
      ApplicationsTableColumn.candidate => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(row.candidateName, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(2.h),
          Text(
            row.candidateId,
            style: context.textTheme.labelSmall?.copyWith(color: secondaryText, fontSize: 12.sp),
          ),
        ],
      ),
      ApplicationsTableColumn.requisition => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(row.jobTitle, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(2.h),
          Text(
            row.requisitionId,
            style: context.textTheme.labelSmall?.copyWith(color: secondaryText, fontSize: 12.sp),
          ),
        ],
      ),
      ApplicationsTableColumn.appliedDate => Text(
        appliedDate,
        style: context.textTheme.bodyMedium?.copyWith(color: primaryText),
      ),
      ApplicationsTableColumn.currentStage => Align(
        alignment: Alignment.centerLeft,
        child: DigifySquareCapsule(
          label: row.currentStage.toUpperCase(),
          backgroundColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      ApplicationsTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: row.status),
      ),
      ApplicationsTableColumn.source => Text(
        row.source,
        style: context.textTheme.bodyMedium?.copyWith(color: primaryText),
      ),
    };
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    if (isLast) return SizedBox(width: width);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
