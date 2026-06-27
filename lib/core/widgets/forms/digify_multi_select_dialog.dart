import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/forms/digify_single_select_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyMultiSelectPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  const DigifyMultiSelectPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });
}

class DigifyMultiSelectDialog<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<T> items;
  final List<String> selectedIds;
  final String searchHint;
  final String emptyMessage;
  final String Function(T item) idBuilder;
  final String Function(T item) labelBuilder;
  final IconData headerIcon;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final DigifyMultiSelectPagination? pagination;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int>? onPageTap;
  final bool showSelectAllAction;

  const DigifyMultiSelectDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.selectedIds,
    required this.idBuilder,
    required this.labelBuilder,
    this.searchHint = 'Search...',
    this.emptyMessage = 'No items found',
    this.headerIcon = Icons.fact_check_rounded,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.pagination,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageTap,
    this.showSelectAllAction = false,
  });

  static Future<List<String>?> show<T>({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<T> items,
    required List<String> selectedIds,
    required String Function(T item) idBuilder,
    required String Function(T item) labelBuilder,
    String searchHint = 'Search...',
    String emptyMessage = 'No items found',
    IconData headerIcon = Icons.fact_check_rounded,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
    DigifyMultiSelectPagination? pagination,
    VoidCallback? onPreviousPage,
    VoidCallback? onNextPage,
    ValueChanged<int>? onPageTap,
    bool showSelectAllAction = false,
  }) {
    final dialog = DigifyMultiSelectDialog<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      selectedIds: selectedIds,
      idBuilder: idBuilder,
      labelBuilder: labelBuilder,
      searchHint: searchHint,
      emptyMessage: emptyMessage,
      headerIcon: headerIcon,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRetry: onRetry,
      pagination: pagination,
      onPreviousPage: onPreviousPage,
      onNextPage: onNextPage,
      onPageTap: onPageTap,
      showSelectAllAction: showSelectAllAction,
    );

    return showAdaptive<List<String>>(context: context, child: dialog, barrierDismissible: false);
  }

  static Future<T?> showAdaptive<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = false,
    double mobileMaxHeightFactor = 0.88,
  }) {
    if (context.isMobile) {
      final mediaQuery = MediaQuery.of(context);
      final availableHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;
      return DigifyBottomSheet.show<T>(
        context,
        type: DigifyBottomSheetType.custom,
        maxHeight: availableHeight * mobileMaxHeightFactor,
        barrierDismissible: barrierDismissible,
        child: child,
      );
    }
    return showDialog<T>(context: context, barrierDismissible: barrierDismissible, builder: (context) => child);
  }

  @override
  State<DigifyMultiSelectDialog<T>> createState() => _DigifyMultiSelectDialogState<T>();
}

class _DigifyMultiSelectDialogState<T> extends State<DigifyMultiSelectDialog<T>> {
  late final Set<String> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedIds.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      if (_query.trim().isEmpty) return true;
      return widget.labelBuilder(item).toLowerCase().contains(_query.trim().toLowerCase());
    }).toList();

    if (context.isMobile) {
      return _buildMobileLayout(filteredItems);
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 580.w,
          constraints: BoxConstraints(maxHeight: 700.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.cardBackground),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const DigifyDivider.horizontal(),
              Expanded(child: _buildContent(filteredItems, isMobile: false)),
              if (widget.pagination != null) ...[const DigifyDivider.horizontal(), _buildPagination()],
              const DigifyDivider.horizontal(),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<T> filteredItems) {
    final canApply = _selectedIds.isNotEmpty;
    final canClear = _selectedIds.isNotEmpty;

    return DigifySingleSelectMobileSheet(
      title: widget.title,
      subtitle: widget.subtitle,
      headerIcon: widget.headerIcon,
      searchField: _buildSearchField(isMobile: true),
      content: _buildContent(filteredItems, isMobile: true),
      pagination: widget.pagination != null ? _buildPagination() : null,
      canApply: canApply,
      canClear: canClear,
      onApply: () => context.pop(_selectedIds.toList()),
      onClear: canClear ? () => setState(() => _selectedIds.clear()) : null,
      onCancel: () => context.pop(),
    );
  }

  Widget _buildPagination() {
    final pagination = widget.pagination!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: PaginationControls(
        currentPage: pagination.currentPage,
        totalPages: pagination.totalPages,
        totalItems: pagination.totalItems,
        pageSize: pagination.pageSize,
        hasNext: pagination.hasNext,
        hasPrevious: pagination.hasPrevious,
        onPrevious: widget.onPreviousPage,
        onNext: widget.onNextPage,
        onPageTap: widget.onPageTap,
        showBorder: false,
        style: PaginationStyle.simple,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(widget.headerIcon, color: AppColors.primary, size: 24.sp),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Gap(2.h),
                    Text(
                      widget.subtitle,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.closeIcon.path,
                onTap: () => context.pop(),
                width: 18.w,
                height: 18.w,
                padding: 6.w,
                borderRadius: BorderRadius.circular(999.r),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          Gap(16.h),
          _buildSearchField(isMobile: false),
        ],
      ),
    );
  }

  Widget _buildSearchField({required bool isMobile}) {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: widget.searchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(onPressed: () => setState(() => _query = ''), icon: const Icon(Icons.close_rounded)),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.55)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: isMobile ? 12.h : 14.h),
      ),
    );
  }

  Widget _buildContent(List<T> filteredItems, {required bool isMobile}) {
    if (widget.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: AppLoadingIndicator(type: LoadingType.circle),
        ),
      );
    }

    if (widget.errorMessage != null && widget.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.errorMessage!,
                style: TextStyle(fontSize: 14.sp, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              if (widget.onRetry != null) ...[
                Gap(10.h),
                TextButton(onPressed: widget.onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      );
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            widget.emptyMessage,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    if (isMobile && widget.showSelectAllAction && filteredItems.isNotEmpty) {
      final allSelected = filteredItems.every((item) => _selectedIds.contains(widget.idBuilder(item)));
      return Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w, end: 12.w, top: 6.h, bottom: 6.h),
            child: Row(
              children: [
                _SelectionCountPill(count: _selectedIds.length),
                const Spacer(),
                _DialogUtilityButton(
                  label: allSelected ? 'Deselect All' : 'Select All',
                  icon: allSelected ? Icons.remove_done_rounded : Icons.done_all_rounded,
                  isPrimary: !allSelected,
                  onTap: () => setState(() {
                    if (allSelected) {
                      for (final item in filteredItems) {
                        _selectedIds.remove(widget.idBuilder(item));
                      }
                    } else {
                      for (final item in filteredItems) {
                        _selectedIds.add(widget.idBuilder(item));
                      }
                    }
                  }),
                ),
              ],
            ),
          ),
          const DigifyDivider.horizontal(),
          Expanded(child: _buildItemsList(filteredItems, isMobile: true)),
        ],
      );
    }

    return _buildItemsList(filteredItems, isMobile: isMobile);
  }

  Widget _buildItemsList(List<T> filteredItems, {required bool isMobile}) {
    return ListView.separated(
      padding: isMobile ? EdgeInsets.zero : EdgeInsets.all(16.w),
      itemCount: filteredItems.length,
      separatorBuilder: (_, _) => isMobile ? const DigifyDivider.thin() : Gap(8.h),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final id = widget.idBuilder(item);
        final isSelected = _selectedIds.contains(id);

        if (isMobile) {
          return DigifySingleSelectMobileListItem(
            label: widget.labelBuilder(item),
            description: null,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedIds.remove(id);
                } else {
                  _selectedIds.add(id);
                }
              });
            },
          );
        }

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedIds.remove(id);
              } else {
                _selectedIds.add(id);
              }
            });
          },
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderGrey.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    widget.labelBuilder(item),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    final allSelected =
        widget.items.isNotEmpty && widget.items.every((item) => _selectedIds.contains(widget.idBuilder(item)));

    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          _DialogUtilityButton(
            label: 'Clear',
            icon: Icons.clear_rounded,
            tone: _DialogUtilityTone.danger,
            enabled: _selectedIds.isNotEmpty,
            onTap: () => setState(() => _selectedIds.clear()),
          ),
          if (widget.showSelectAllAction) ...[
            Gap(8.w),
            _DialogUtilityButton(
              label: allSelected ? 'Deselect All' : 'Select All',
              icon: allSelected ? Icons.remove_done_rounded : Icons.done_all_rounded,
              isPrimary: !allSelected,
              onTap: () => setState(() {
                if (allSelected) {
                  for (final item in widget.items) {
                    _selectedIds.remove(widget.idBuilder(item));
                  }
                } else {
                  for (final item in widget.items) {
                    _selectedIds.add(widget.idBuilder(item));
                  }
                }
              }),
            ),
          ],
          const Spacer(),
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          Gap(10.w),
          ElevatedButton(onPressed: () => context.pop(_selectedIds.toList()), child: const Text('Apply')),
        ],
      ),
    );
  }
}

enum _DialogUtilityTone { neutral, danger }

class _DialogUtilityButton extends StatelessWidget {
  const _DialogUtilityButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.enabled = true,
    this.isPrimary = false,
    this.tone = _DialogUtilityTone.neutral,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool isPrimary;
  final _DialogUtilityTone tone;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = !enabled
        ? AppColors.textSecondary.withValues(alpha: 0.4)
        : tone == _DialogUtilityTone.danger
        ? AppColors.error
        : isPrimary
        ? Colors.white
        : AppColors.textSecondary;

    final backgroundColor = !enabled
        ? AppColors.background
        : tone == _DialogUtilityTone.danger
        ? AppColors.error.withValues(alpha: 0.08)
        : isPrimary
        ? AppColors.primary
        : AppColors.background;

    final borderColor = !enabled
        ? AppColors.borderGrey.withValues(alpha: 0.5)
        : tone == _DialogUtilityTone.danger
        ? AppColors.error.withValues(alpha: 0.18)
        : isPrimary
        ? AppColors.primary
        : AppColors.borderGrey.withValues(alpha: 0.9);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: foregroundColor),
              Gap(6.w),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCountPill extends StatelessWidget {
  const _SelectionCountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isActive = count > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: isActive ? AppColors.primary.withValues(alpha: 0.24) : AppColors.borderGrey.withValues(alpha: 0.8),
        ),
      ),
      child: Text(
        '$count selected',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
