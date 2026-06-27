import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/widgets/common/pagination_controls.dart';
import '../../../../domain/models/overtime/overtime_record.dart';
import '../../../../data/config/overtime_table_config.dart';
import 'overtime_table_header.dart';
import 'overtime_table_row.dart';
import 'overtime_expanded_panel.dart';
import 'overtime_table_skeleton.dart';

final overtimeExpandedIndexProvider = StateProvider<int?>((ref) => null);

class OvertimeTable extends ConsumerWidget {
  final AppLocalizations localizations;
  final List<OvertimeRecord> records;
  final bool isDark;
  final bool isLoading;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(OvertimeRecord)? onEdit;
  final bool? paginationIsLoading;

  const OvertimeTable({
    super.key,
    required this.localizations,
    required this.records,
    required this.isDark,
    this.isLoading = false,
    this.currentPage = 1,
    this.pageSize = 10,
    required this.totalItems,
    this.onPrevious,
    this.onNext,
    this.onEdit,
    this.paginationIsLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIndex = ref.watch(overtimeExpandedIndexProvider);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OvertimeTableHeader(isDark: isDark, localizations: localizations),

                  if (isLoading)
                    OvertimeTableSkeleton(localizations: localizations, isDark: isDark)
                  else if (records.isEmpty && !isLoading)
                    SizedBox(
                      width: OvertimeTableConfig.totalWidth.w,
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
                    ...List.generate(records.length, (index) {
                      final record = records[index];
                      final isExpanded = expandedIndex == index;
                      final isLast = index == records.length - 1;

                      return Column(
                        children: [
                          OvertimeTableRow(
                            record: record,
                            localizations: localizations,
                            isDark: isDark,
                            isExpanded: isExpanded,
                            onToggle: () {
                              final notifier = ref.read(overtimeExpandedIndexProvider.notifier);
                              if (expandedIndex == index) {
                                notifier.state = null;
                              } else {
                                notifier.state = index;
                              }
                            },
                            onEdit: onEdit,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isExpanded) OvertimeExpandedPanel(record: record, isDark: isDark),
                                if (isExpanded && !isLast)
                                  Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalItems == 0 ? 1 : (totalItems / pageSize).ceil(),
            totalItems: totalItems,
            pageSize: pageSize,
            hasNext: (currentPage * pageSize) < totalItems,
            hasPrevious: currentPage > 1,
            onPrevious: onPrevious,
            onNext: onNext,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
