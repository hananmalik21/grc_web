import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pagination controls widget
class PaginationControlsWidget extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final StructureListState state;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;

  const PaginationControlsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.state,
    required this.structureListProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagination = state.pagination;
    if (pagination == null) return const SizedBox.shrink();

    // Use ref.read to get the notifier
    final notifier = ref.read(structureListProvider.notifier);
    final currentPage = pagination.page;
    final totalPages = pagination.totalPages;
    final pageSize = state.pageSize;
    final totalItems = pagination.total;

    // Generate page numbers to display
    List<int> getPageNumbers() {
      if (totalPages <= 7) {
        // Show all pages if 7 or fewer
        return List.generate(totalPages, (index) => index + 1);
      } else {
        // Show pages with ellipsis
        List<int> pages = [];
        if (currentPage <= 3) {
          // Show first 5 pages
          pages = [1, 2, 3, 4, 5];
        } else if (currentPage >= totalPages - 2) {
          // Show last 5 pages
          pages = [totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
        } else {
          // Show current page with 2 pages on each side
          pages = [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2];
        }
        return pages;
      }
    }

    final pageNumbers = getPageNumbers();
    final showFirstEllipsis = totalPages > 7 && currentPage > 4;
    final showLastEllipsis = totalPages > 7 && currentPage < totalPages - 3;

    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Page info
          Text(
            'Showing ${((currentPage - 1) * pageSize) + 1} - ${currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize} of $totalItems items',
            style: TextStyle(fontSize: 13.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          // Pagination buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page button
              if (totalPages > 7 && currentPage > 4)
                _buildPageButton(
                  context,
                  isDark,
                  page: 1,
                  currentPage: currentPage,
                  onTap: () {
                    notifier.goToPage(1);
                  },
                ),
              if (totalPages > 7 && currentPage > 4) SizedBox(width: 4.w),
              if (showFirstEllipsis)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    '...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              if (showFirstEllipsis) SizedBox(width: 4.w),

              // Previous button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: pagination.hasPrevious && !state.isLoading
                      ? () async {
                          await notifier.loadPreviousPage();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: state.isLoading && currentPage > 1
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.chevron_left,
                            size: 18.sp,
                            color: pagination.hasPrevious && !state.isLoading
                                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                                : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                          ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Page number buttons
              ...pageNumbers.map((page) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _buildPageButton(
                    context,
                    isDark,
                    page: page,
                    currentPage: currentPage,
                    onTap: () {
                      notifier.goToPage(page);
                    },
                  ),
                );
              }),

              SizedBox(width: 4.w),
              // Next button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: pagination.hasNext && !state.isLoadingMore
                      ? () async {
                          await notifier.loadNextPage();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: state.isLoadingMore && currentPage < totalPages
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.chevron_right,
                            size: 18.sp,
                            color: pagination.hasNext && !state.isLoadingMore
                                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                                : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                          ),
                  ),
                ),
              ),

              if (showLastEllipsis) SizedBox(width: 4.w),
              if (showLastEllipsis)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    '...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              if (showLastEllipsis) SizedBox(width: 4.w),
              // Last page button
              if (totalPages > 7 && currentPage < totalPages - 3) SizedBox(width: 4.w),
              if (totalPages > 7 && currentPage < totalPages - 3)
                _buildPageButton(
                  context,
                  isDark,
                  page: totalPages,
                  currentPage: currentPage,
                  onTap: () {
                    notifier.goToPage(totalPages);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    BuildContext context,
    bool isDark, {
    required int page,
    required int currentPage,
    required VoidCallback onTap,
  }) {
    final isActive = page == currentPage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
            borderRadius: BorderRadius.circular(6.r),
            border: isActive
                ? null
                : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
