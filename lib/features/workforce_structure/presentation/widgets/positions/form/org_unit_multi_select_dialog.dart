import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/org_level_picker_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgUnitMultiSelectDialog extends ConsumerStatefulWidget {
  const OrgUnitMultiSelectDialog({
    super.key,
    required this.levelName,
    required this.pickerKey,
    required this.preSelectedIds,
  });

  final String levelName;
  final OrgLevelPickerKey pickerKey;
  final Set<String> preSelectedIds;

  static Future<List<OrgUnit>?> show({
    required BuildContext context,
    required String levelName,
    required OrgLevelPickerKey pickerKey,
    required Set<String> preSelectedIds,
  }) {
    return showDialog<List<OrgUnit>>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          OrgUnitMultiSelectDialog(levelName: levelName, pickerKey: pickerKey, preSelectedIds: preSelectedIds),
    );
  }

  @override
  ConsumerState<OrgUnitMultiSelectDialog> createState() => _OrgUnitMultiSelectDialogState();
}

class _OrgUnitMultiSelectDialogState extends ConsumerState<OrgUnitMultiSelectDialog> {
  late final Set<String> _selectedIds;
  late final Map<String, OrgUnit> _selectedUnits;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.preSelectedIds);
    _selectedUnits = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(orgLevelPickerProvider(widget.pickerKey).notifier).loadOptions();
    });
  }

  void _toggle(OrgUnit unit) {
    setState(() {
      if (_selectedIds.contains(unit.orgUnitId)) {
        _selectedIds.remove(unit.orgUnitId);
        _selectedUnits.remove(unit.orgUnitId);
      } else {
        _selectedIds.add(unit.orgUnitId);
        _selectedUnits[unit.orgUnitId] = unit;
      }
    });
  }

  void _confirm() {
    final state = ref.read(orgLevelPickerProvider(widget.pickerKey));
    // Collect selected units from current page + previously cached
    final fromPage = state.options.where((u) => _selectedIds.contains(u.orgUnitId)).toList();
    final preserved = _selectedUnits.values
        .where((u) => !state.options.any((o) => o.orgUnitId == u.orgUnitId))
        .toList();
    context.pop([...preserved, ...fromPage]);
  }

  @override
  Widget build(BuildContext context) {
    final pickerState = ref.watch(orgLevelPickerProvider(widget.pickerKey));

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 550.w,
          height: 650.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.white),
          child: Column(
            children: [
              _Header(
                levelName: widget.levelName,
                selectedCount: _selectedIds.length,
                searchQuery: pickerState.searchQuery,
                onSearchChanged: (v) => ref.read(orgLevelPickerProvider(widget.pickerKey).notifier).setSearchQuery(v),
                onCancel: () => context.pop(null),
                onConfirm: _confirm,
              ),
              Expanded(child: _buildContent(pickerState)),
              PaginationControls(
                currentPage: pickerState.page,
                totalPages: pickerState.totalPages,
                totalItems: pickerState.totalItems,
                pageSize: pickerState.pageSize,
                hasNext: pickerState.hasNext,
                hasPrevious: pickerState.hasPrevious,
                isLoading: false,
                onPrevious: pickerState.hasPrevious
                    ? () => ref.read(orgLevelPickerProvider(widget.pickerKey).notifier).goToPage(pickerState.page - 1)
                    : null,
                onNext: pickerState.hasNext
                    ? () => ref.read(orgLevelPickerProvider(widget.pickerKey).notifier).goToPage(pickerState.page + 1)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(OrgLevelPickerState pickerState) {
    if (pickerState.isLoading) return const OrgUnitSelectionSkeleton();

    if (pickerState.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pickerState.error!,
              style: TextStyle(color: AppColors.error, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            Gap(12.h),
            TextButton(
              onPressed: () => ref.read(orgLevelPickerProvider(widget.pickerKey).notifier).loadOptions(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (pickerState.options.isEmpty) {
      return Center(
        child: Text(
          'No ${widget.levelName} units found.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: pickerState.options.length,
      separatorBuilder: (_, _) => Gap(8.h),
      itemBuilder: (context, index) {
        final unit = pickerState.options[index];
        final isSelected = _selectedIds.contains(unit.orgUnitId);

        return InkWell(
          onTap: () => _toggle(unit),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
                  size: 20.sp,
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    unit.orgUnitNameEn,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.levelName,
    required this.selectedCount,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  final String levelName;
  final int selectedCount;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select ${widget.levelName}',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    if (widget.selectedCount > 0) ...[
                      Gap(2.h),
                      Text(
                        '${widget.selectedCount} selected',
                        style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
                      ),
                    ],
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
                ),
              ),
              Gap(8.w),
              ElevatedButton(
                onPressed: widget.onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text('Confirm', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
          Gap(12.h),
          TextField(
            controller: _controller,
            onChanged: widget.onSearchChanged,
            style: TextStyle(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: 'Search ${widget.levelName}...',
              hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary.withValues(alpha: 0.6)),
              prefixIcon: Icon(Icons.search, size: 20.sp, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.borderGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.borderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
