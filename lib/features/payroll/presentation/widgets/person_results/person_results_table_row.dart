import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_table_width_provider.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/person_result_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonResultsTableRow extends ConsumerWidget {
  const PersonResultsTableRow({required this.employee, required this.isDark, super.key});

  final PersonResultEmployee employee;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(personResultsTableWidthsProvider);
    final dividerWidths = state.columnOrder.map(state.widthFor).toList();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(PersonResultDetailPage.routeName, extra: employee),
        hoverColor: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.04),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder, width: 1.w),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    for (var index = 0; index < dividerWidths.length; index++)
                      _DividerCell(width: dividerWidths[index], isLast: index == dividerWidths.length - 1),
                  ],
                ),
              ),
              Row(
                children: [
                  for (final column in state.columnOrder)
                    _DataCell(width: state.widthFor(column), child: _buildCellContent(context, loc, column)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(BuildContext context, AppLocalizations loc, PersonResultsTableColumn column) {
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final status = employee.isActive ? loc.active : loc.inactive;

    return switch (column) {
      PersonResultsTableColumn.name => Row(
        children: [
          AppAvatar(fallbackInitial: employee.name, size: 36.w),
          Gap(10.w),
          Expanded(
            child: Text(
              employee.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
        ],
      ),
      PersonResultsTableColumn.businessTitle => Text(
        employee.businessTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: primaryTextColor),
      ),
      PersonResultsTableColumn.personNumber => Text(
        employee.personNumber,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultsTableColumn.assignmentNumber => Text(
        employee.assignmentNumber,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultsTableColumn.assignmentStatus => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: status),
      ),
      PersonResultsTableColumn.workerType => Text(
        employee.workerType,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: primaryTextColor),
      ),
      PersonResultsTableColumn.workEmail => Text(
        employee.workEmail,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultsTableColumn.workPhone => Text(
        employee.workPhone,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
    };
  }
}

class _DividerCell extends StatelessWidget {
  const _DividerCell({required this.width, required this.isLast});

  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
