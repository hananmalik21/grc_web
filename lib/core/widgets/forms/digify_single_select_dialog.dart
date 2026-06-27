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

class DigifySingleSelectPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  const DigifySingleSelectPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });
}

class DigifySingleSelectDialog<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<T> items;
  final String? selectedId;
  final String searchHint;
  final String emptyMessage;
  final String Function(T item) idBuilder;
  final String Function(T item) labelBuilder;
  final String? Function(T item)? descriptionBuilder;
  final Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder;
  final IconData headerIcon;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final DigifySingleSelectPagination? pagination;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int>? onPageTap;
  final VoidCallback? onClearAndClose;

  const DigifySingleSelectDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.selectedId,
    required this.idBuilder,
    required this.labelBuilder,
    this.descriptionBuilder,
    this.itemBuilder,
    this.searchHint = 'Search...',
    this.emptyMessage = 'No items found',
    this.headerIcon = Icons.checklist_rounded,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.pagination,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageTap,
    this.onClearAndClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<T> items,
    required String? selectedId,
    required String Function(T item) idBuilder,
    required String Function(T item) labelBuilder,
    String? Function(T item)? descriptionBuilder,
    Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder,
    String searchHint = 'Search...',
    String emptyMessage = 'No items found',
    IconData headerIcon = Icons.checklist_rounded,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
    DigifySingleSelectPagination? pagination,
    VoidCallback? onPreviousPage,
    VoidCallback? onNextPage,
    ValueChanged<int>? onPageTap,
    VoidCallback? onClearAndClose,
  }) {
    final dialog = DigifySingleSelectDialog<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      selectedId: selectedId,
      idBuilder: idBuilder,
      labelBuilder: labelBuilder,
      descriptionBuilder: descriptionBuilder,
      itemBuilder: itemBuilder,
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
      onClearAndClose: onClearAndClose,
    );

    return showAdaptive<T>(context: context, child: dialog, barrierDismissible: false);
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
  State<DigifySingleSelectDialog<T>> createState() => _DigifySingleSelectDialogState<T>();
}

class _DigifySingleSelectDialogState<T> extends State<DigifySingleSelectDialog<T>> {
  String? _selectedId;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(covariant DigifySingleSelectDialog<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_containsId(widget.items, _selectedId)) {
      _selectedId = widget.selectedId;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final filteredItems = widget.items.where((item) {
      if (_query.trim().isEmpty) return true;
      final normalizedQuery = _query.trim().toLowerCase();
      final label = widget.labelBuilder(item).toLowerCase();
      final description = widget.descriptionBuilder?.call(item)?.toLowerCase() ?? '';
      return label.contains(normalizedQuery) || description.contains(normalizedQuery);
    }).toList();

    return isMobile ? _buildMobileContent(context, filteredItems) : _buildDesktopLayout(context, filteredItems);
  }

  Widget _buildMobileContent(BuildContext context, List<T> filteredItems) {
    final canApply = _selectedId != null;

    return DigifySingleSelectMobileSheet(
      title: widget.title,
      subtitle: widget.subtitle,
      headerIcon: widget.headerIcon,
      searchField: _buildSearchField(isMobile: true),
      content: _buildContent(filteredItems, isMobile: true),
      pagination: widget.pagination != null ? _buildPagination() : null,
      canApply: canApply,
      canClear: _selectedId != null,
      onApply: canApply
          ? () {
              final selected = _itemById(_selectedId);
              if (selected == null) {
                context.pop();
                return;
              }
              context.pop(selected);
            }
          : null,
      onClear: _selectedId == null
          ? null
          : () {
              if (widget.onClearAndClose != null) {
                widget.onClearAndClose!();
                return;
              }
              setState(() => _selectedId = null);
            },
      onCancel: () => context.pop(),
    );
  }

  // ── Desktop: centered dialog ────────────────────────────────────────────────

  Widget _buildDesktopLayout(BuildContext context, List<T> filteredItems) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 620.w,
          constraints: BoxConstraints(maxHeight: 740.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.cardBackground),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDesktopHeader(context),
              const DigifyDivider.horizontal(),
              Expanded(child: _buildContent(filteredItems, isMobile: false)),
              if (widget.pagination != null) ...[const DigifyDivider.horizontal(), _buildPagination()],
              const DigifyDivider.horizontal(),
              _buildDesktopActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
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

  Widget _buildDesktopActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          TextButton(
            onPressed: _selectedId == null
                ? null
                : () {
                    if (widget.onClearAndClose != null) {
                      widget.onClearAndClose!();
                      return;
                    }
                    setState(() => _selectedId = null);
                  },
            child: const Text('Clear'),
          ),
          const Spacer(),
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          Gap(10.w),
          ElevatedButton(
            onPressed: _selectedId == null
                ? null
                : () {
                    final selected = _itemById(_selectedId);
                    if (selected == null) {
                      context.pop();
                      return;
                    }
                    context.pop(selected);
                  },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  // ── Shared ──────────────────────────────────────────────────────────────────

  Widget _buildSearchField({required bool isMobile}) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: widget.searchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() => _query = '');
                  _searchController.clear();
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
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

    return isMobile ? _buildMobileList(filteredItems) : _buildDesktopList(filteredItems);
  }

  Widget _buildMobileList(List<T> filteredItems) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: filteredItems.length,
      separatorBuilder: (_, _) => const DigifyDivider.thin(),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final id = widget.idBuilder(item);
        final isSelected = _selectedId == id;

        if (widget.itemBuilder != null) {
          return InkWell(
            onTap: () => setState(() => _selectedId = id),
            child: widget.itemBuilder!(context, item, isSelected),
          );
        }

        return DigifySingleSelectMobileListItem(
          label: widget.labelBuilder(item),
          description: widget.descriptionBuilder?.call(item),
          isSelected: isSelected,
          onTap: () => setState(() => _selectedId = id),
        );
      },
    );
  }

  Widget _buildDesktopList(List<T> filteredItems) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredItems.length,
      separatorBuilder: (_, _) => Gap(8.h),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final id = widget.idBuilder(item);
        final isSelected = _selectedId == id;

        if (widget.itemBuilder != null) {
          return InkWell(
            onTap: () => setState(() => _selectedId = id),
            borderRadius: BorderRadius.circular(12.r),
            child: widget.itemBuilder!(context, item, isSelected),
          );
        }

        return InkWell(
          onTap: () => setState(() => _selectedId = id),
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
                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.labelBuilder(item),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      if (widget.descriptionBuilder?.call(item)?.trim().isNotEmpty == true) ...[
                        Gap(3.h),
                        Text(
                          widget.descriptionBuilder!(item)!,
                          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        isLoading: false,
      ),
    );
  }

  bool _containsId(List<T> items, String? id) {
    if (id == null) return false;
    return items.any((item) => widget.idBuilder(item) == id);
  }

  T? _itemById(String? id) {
    if (id == null) return null;
    for (final item in widget.items) {
      if (widget.idBuilder(item) == id) return item;
    }
    return null;
  }
}
