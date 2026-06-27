import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendancePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int?> onItemsPerPageChanged;
  final bool isDark;

  const AttendancePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final startItem = ((currentPage - 1) * itemsPerPage) + 1;
    final endItem = currentPage * itemsPerPage > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: context.isMobile
          ? Wrap(
              spacing: 24.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildItemsPerPage(context),
                _buildShowingItems(context, startItem, endItem),
                _buildNavigation(context),
                _buildGoToPage(context),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemsPerPage(context),
                _buildShowingItems(context, startItem, endItem),
                _buildNavigation(context),
                _buildGoToPage(context),
              ],
            ),
    );
  }

  Widget _buildItemsPerPage(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Items per page:',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : const Color(0xFF4A5565),
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(12.w),
        _buildDropdown(context),
      ],
    );
  }

  Widget _buildShowingItems(BuildContext context, int startItem, int endItem) {
    return Text(
      'Showing $startItem-$endItem of $totalItems',
      style: context.textTheme.bodyMedium?.copyWith(
        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavButton(
          icon: Icons.chevron_left,
          enabled: currentPage > 1,
          onTap: () => onPageChanged(currentPage - 1),
        ),
        Gap(8.w),
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text('$currentPage', style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Gap(8.w),
        _buildNavButton(
          icon: Icons.chevron_right,
          enabled: currentPage < totalPages,
          onTap: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }

  Widget _buildGoToPage(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Go to page:',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : const Color(0xFF4A5565),
          ),
        ),
        Gap(12.w),
        SizedBox(
          width: 60.w,
          height: 40.h,
          child: TextFormField(
            initialValue: currentPage.toString(),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onFieldSubmitted: (value) {
              final page = int.tryParse(value);
              if (page != null && page >= 1 && page <= totalPages) {
                onPageChanged(page);
              }
            },
          ),
        ),
        Gap(12.w),
        Text(
          'of $totalPages',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : const Color(0xFF4A5565),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: itemsPerPage,
          items: [10, 20, 50, 100].map((int value) {
            return DropdownMenuItem<int>(value: value, child: Text('$value'));
          }).toList(),
          onChanged: onItemsPerPageChanged,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required bool enabled, required VoidCallback onTap}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: enabled
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.1),
        ),
        child: Icon(
          icon,
          color: enabled
              ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172B))
              : (isDark ? AppColors.textTertiaryDark : Colors.grey),
        ),
      ),
    );
  }
}
