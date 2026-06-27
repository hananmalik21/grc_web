import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_overtime_request_dialog/edit_overtime_request_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_overtime_request_mobile_sheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/component_overtime_filter_bar.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/component_overtime_stats.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/search/component_overtime_search_and_actions.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/search/component_overtime_search_and_actions_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/overtime_list_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/table/component_overtime_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OvertimeContent extends ConsumerWidget {
  const OvertimeContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final state = ref.watch(overtimeManagementProvider);
    final notifier = ref.read(overtimeManagementProvider.notifier);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            header,
            enterpriseSelector,
            const ComponentOvertimeFilterBar(),
            const ComponentOvertimeStats(),
            if (isMobile)
              OvertimeSearchAndActionsMobile(localizations: localizations, isDark: isDark)
            else
              OvertimeSearchAndActions(localizations: localizations, isDark: isDark),
            if (isMobile)
              OvertimeListMobile(onEdit: (record) => EditOvertimeMobileSheet.show(context, record))
            else
              OvertimeTable(
                localizations: localizations,
                records: state.records ?? [],
                totalItems: state.totalItems,
                isLoading: state.isLoading,
                currentPage: state.currentPage,
                pageSize: state.pageSize,
                paginationIsLoading: state.isLoading && (state.records?.isNotEmpty ?? false),
                onPrevious: state.currentPage > 1 ? () => notifier.goToPage(state.currentPage - 1) : null,
                onNext: state.hasMore ? () => notifier.goToPage(state.currentPage + 1) : null,
                isDark: isDark,
                onEdit: (record) => EditOvertimeRequestDialog.show(context, record),
              ),
          ],
        ),
      ),
    );
  }
}
