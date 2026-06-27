import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/table/org_units_table_header.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/table/org_units_table_row.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/table/org_units_table_skeleton.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

@immutable
class OrgUnitsDeleteState {
  const OrgUnitsDeleteState({this.deletingOrgUnitId});

  final String? deletingOrgUnitId;

  bool isDeleting(String orgUnitId) => deletingOrgUnitId == orgUnitId;

  OrgUnitsDeleteState copyWithDeleting(String? orgUnitId) => OrgUnitsDeleteState(deletingOrgUnitId: orgUnitId);
}

class OrgUnitsTableWidget extends StatelessWidget {
  final List<OrgStructureLevel> units;
  final bool isLoading;
  final bool isDark;
  final AppLocalizations localizations;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;
  final OrgUnitsDeleteState deleteState;
  final bool? paginationIsLoading;

  const OrgUnitsTableWidget({
    super.key,
    required this.units,
    required this.isLoading,
    required this.isDark,
    required this.localizations,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.deleteState = const OrgUnitsDeleteState(),
    this.paginationIsLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 400.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrgUnitsTableHeader(isDark: isDark),
                    if (isLoading && units.isEmpty)
                      const OrgUnitsTableSkeleton()
                    else if (units.isEmpty && !isLoading)
                      SizedBox(
                        width: 1200.w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.h),
                          child: Center(
                            child: Text(
                              localizations.noResultsFound,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ...units.asMap().entries.map(
                        (entry) => OrgUnitsTableRow(
                          unit: entry.value,
                          index: ((currentPage - 1) * pageSize) + entry.key + 1,
                          isDark: isDark,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                          onDelete: onDelete,
                          isDeleteLoading: deleteState.isDeleting(entry.value.orgUnitId),
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
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }
}
