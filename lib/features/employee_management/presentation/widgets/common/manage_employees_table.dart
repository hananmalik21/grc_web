import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/widgets/table/employee_table_header.dart';
import 'package:grc/features/employee_management/presentation/widgets/table/employee_table_row.dart';
import 'package:grc/features/employee_management/presentation/widgets/table/employee_table_skeleton.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageEmployeesTable extends StatelessWidget {
  final AppLocalizations localizations;
  final List<EmployeeListItem> employees;
  final bool isDark;
  final bool isLoading;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(EmployeeListItem)? onView;
  final Function(EmployeeListItem)? onEdit;
  final VoidCallback? onMore;
  final bool? paginationIsLoading;

  const ManageEmployeesTable({
    super.key,
    required this.localizations,
    required this.employees,
    required this.isDark,
    this.isLoading = false,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    this.onView,
    this.onEdit,
    this.onMore,
    this.paginationIsLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmployeeTableHeader(isDark: isDark, localizations: localizations),
                    if (isLoading && employees.isEmpty)
                      EmployeeTableSkeleton(localizations: localizations)
                    else if (employees.isEmpty && !isLoading)
                      SizedBox(
                        width: 900.w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.h),
                          child: Center(
                            child: Text(
                              localizations.noResultsFound,
                              style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      )
                    else
                      ...employees.asMap().entries.map(
                        (entry) => EmployeeTableRow(
                          employee: entry.value,
                          index: entry.key + 1,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                          onMore: onMore,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (paginationInfo != null) ...[
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              isLoading: paginationIsLoading ?? isLoading,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }
}
