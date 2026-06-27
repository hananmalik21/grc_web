import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<int>? onPageTap;
  final bool isLoading;
  final bool showPageNumbers;
  final EdgeInsets? padding;
  final bool showBorder;
  final PaginationStyle style;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
    this.onPrevious,
    this.onNext,
    this.onPageTap,
    this.isLoading = false,
    this.showPageNumbers = false,
    this.padding,
    this.showBorder = true,
    this.style = PaginationStyle.simple,
  });

  factory PaginationControls.fromPaginationInfo({
    required PaginationInfo paginationInfo,
    required int currentPage,
    required int pageSize,
    VoidCallback? onPrevious,
    VoidCallback? onNext,
    ValueChanged<int>? onPageTap,
    bool isLoading = false,
    EdgeInsets? padding,
    bool showBorder = true,
    PaginationStyle style = PaginationStyle.simple,
    Key? key,
  }) {
    return PaginationControls(
      key: key,
      currentPage: currentPage,
      totalPages: paginationInfo.totalPages,
      totalItems: paginationInfo.totalItems,
      pageSize: pageSize,
      hasNext: paginationInfo.hasNext,
      hasPrevious: paginationInfo.hasPrevious,
      onPrevious: onPrevious,
      onNext: onNext,
      onPageTap: onPageTap,
      isLoading: isLoading,
      padding: padding,
      showBorder: showBorder,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hasAnyItems = totalItems > 0;
    final startItem = hasAnyItems ? ((currentPage - 1) * pageSize) + 1 : 0;
    final endItem = hasAnyItems ? (currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize) : 0;

    final controls = style == PaginationStyle.simple
        ? _buildSimpleControls(context, isDark)
        : _buildFullControls(context, isDark);

    final infoText = Text(
      'Showing $startItem - $endItem of $totalItems items',
      style: TextStyle(fontSize: 13.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
    );

    return Container(
      padding: padding ?? EdgeInsetsDirectional.all(16.w),
      decoration: showBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
              ),
            )
          : null,
      child: context.isMobileLayout
          ? MobilePaginationControls(
              isDark: isDark,
              currentPage: currentPage,
              totalPages: totalPages,
              hasPrevious: hasPrevious,
              hasNext: hasNext,
              onPrevious: onPrevious,
              onNext: onNext,
            )
          : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [infoText, controls]),
    );
  }

  Widget _buildSimpleControls(BuildContext context, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavButton(
          context: context,
          isDark: isDark,
          icon: Icons.chevron_left,
          enabled: hasPrevious && !isLoading,
          onTap: onPrevious,
        ),
        Gap(8.w),
        Text(
          'Page $currentPage of $totalPages',
          style: TextStyle(fontSize: 13.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
        Gap(8.w),
        _buildNavButton(
          context: context,
          isDark: isDark,
          icon: Icons.chevron_right,
          enabled: hasNext && !isLoading,
          onTap: onNext,
        ),
      ],
    );
  }

  Widget _buildFullControls(BuildContext context, bool isDark) {
    final pageNumbers = _generatePageNumbers();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (totalPages > 7 && currentPage > 4)
          _buildPageButton(context: context, isDark: isDark, page: 1, onTap: () => onPageTap?.call(1)),
        if (totalPages > 7 && currentPage > 4) Gap(4.w),
        if (_shouldShowFirstEllipsis())
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '...',
              style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
          ),
        if (_shouldShowFirstEllipsis()) Gap(4.w),
        _buildNavButton(
          context: context,
          isDark: isDark,
          icon: Icons.chevron_left,
          enabled: hasPrevious && !isLoading,
          onTap: onPrevious,
        ),
        Gap(4.w),
        ...pageNumbers.map((page) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: _buildPageButton(
              context: context,
              isDark: isDark,
              page: page,
              isActive: page == currentPage,
              onTap: () => onPageTap?.call(page),
            ),
          );
        }),
        Gap(4.w),
        _buildNavButton(
          context: context,
          isDark: isDark,
          icon: Icons.chevron_right,
          enabled: hasNext && !isLoading,
          onTap: onNext,
        ),
        if (_shouldShowLastEllipsis()) Gap(4.w),
        if (_shouldShowLastEllipsis())
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '...',
              style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
          ),
        if (_shouldShowLastEllipsis()) Gap(4.w),
        if (totalPages > 7 && currentPage < totalPages - 3) Gap(4.w),
        if (totalPages > 7 && currentPage < totalPages - 3)
          _buildPageButton(
            context: context,
            isDark: isDark,
            page: totalPages,
            onTap: () => onPageTap?.call(totalPages),
          ),
      ],
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
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
          child: isLoading
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
                  icon,
                  size: 18.sp,
                  color: enabled
                      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                      : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                ),
        ),
      ),
    );
  }

  Widget _buildPageButton({
    required BuildContext context,
    required bool isDark,
    required int page,
    bool isActive = false,
    required VoidCallback? onTap,
  }) {
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

  List<int> _generatePageNumbers() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (index) => index + 1);
    } else {
      if (currentPage <= 3) {
        return [1, 2, 3, 4, 5];
      } else if (currentPage >= totalPages - 2) {
        return [totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
      } else {
        return [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2];
      }
    }
  }

  bool _shouldShowFirstEllipsis() {
    return totalPages > 7 && currentPage > 4;
  }

  bool _shouldShowLastEllipsis() {
    return totalPages > 7 && currentPage < totalPages - 3;
  }
}

enum PaginationStyle { simple, full }

class MobilePaginationControls extends StatelessWidget {
  const MobilePaginationControls({
    super.key,
    required this.isDark,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    this.onPrevious,
    this.onNext,
  });

  final bool isDark;
  final int currentPage;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MobileNavButton(
          isDark: isDark,
          assetPath: Assets.icons.workforce.chevronLeft.path,
          enabled: hasPrevious,
          onTap: onPrevious,
        ),
        Text(
          'Page $currentPage of $totalPages',
          style: context.textTheme.labelMedium?.copyWith(
            fontSize: 13.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        _MobileNavButton(
          isDark: isDark,
          assetPath: Assets.icons.workforce.chevronRight.path,
          enabled: hasNext,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _MobileNavButton extends StatelessWidget {
  const _MobileNavButton({required this.isDark, required this.assetPath, required this.enabled, this.onTap});

  final bool isDark;
  final String assetPath;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      width: 40.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: enabled ? onTap : null,
          child: Center(
            child: DigifyAsset(
              assetPath: assetPath,
              width: 20.w,
              height: 20.w,
              color: enabled
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                  : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
            ),
          ),
        ),
      ),
    );
  }
}
