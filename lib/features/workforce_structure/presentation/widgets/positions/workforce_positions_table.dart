import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/table/position_table_header.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/table/position_table_row.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/table/position_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkforcePositionsTable extends ConsumerWidget {
  final AppLocalizations localizations;
  final List<Position> positions;
  final bool isDark;
  final bool isLoading;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  const WorkforcePositionsTable({
    super.key,
    required this.localizations,
    required this.positions,
    required this.isDark,
    this.isLoading = false,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionState = ref.watch(positionNotifierProvider);
    final hasPaginationData = positionState.totalPages > 0 || positions.isNotEmpty;
    final paginationInfo = PaginationInfo(
      currentPage: positionState.currentPage,
      totalPages: positionState.totalPages,
      totalItems: positionState.totalItems,
      pageSize: positionState.pageSize,
      hasNext: positionState.hasNextPage,
      hasPrevious: positionState.hasPreviousPage,
    );

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
                    PositionTableHeader(isDark: isDark, localizations: localizations),
                    if (isLoading && positions.isEmpty)
                      PositionTableSkeleton(localizations: localizations)
                    else if (positions.isEmpty && !isLoading)
                      SizedBox(
                        width: 1200.w,
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
                      ...positions.map(
                        (position) => PositionTableRow(
                          position: position,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasPaginationData) ...[
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo,
              currentPage: positionState.currentPage,
              pageSize: positionState.pageSize,
              onPrevious: positionState.hasPreviousPage && !isLoading
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage - 1)
                  : null,
              onNext: positionState.hasNextPage && !isLoading
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage + 1)
                  : null,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }
}
