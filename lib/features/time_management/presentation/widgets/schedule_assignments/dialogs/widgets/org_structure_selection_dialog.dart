import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/search_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:ui';

class OrgStructureSelectionDialog extends ConsumerStatefulWidget {
  final OrgStructure? selectedStructure;
  final List<OrgStructure> structures;
  final int? enterpriseId;

  const OrgStructureSelectionDialog({super.key, this.selectedStructure, required this.structures, this.enterpriseId});

  static Future<OrgStructure?> show({
    required BuildContext context,
    OrgStructure? selectedStructure,
    required List<OrgStructure> structures,
    int? enterpriseId,
  }) async {
    return await showDialog<OrgStructure>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrgStructureSelectionDialog(
        selectedStructure: selectedStructure,
        structures: structures,
        enterpriseId: enterpriseId,
      ),
    );
  }

  @override
  ConsumerState<OrgStructureSelectionDialog> createState() => _OrgStructureSelectionDialogState();
}

class _OrgStructureSelectionDialogState extends ConsumerState<OrgStructureSelectionDialog> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<OrgStructure> _getStructures() {
    if (widget.enterpriseId != null) {
      final enterpriseState = ref.watch(enterpriseOrgStructureNotifierProvider(widget.enterpriseId!));
      return enterpriseState.allStructures;
    }
    return widget.structures;
  }

  List<OrgStructure> get _filteredStructures {
    final structures = _getStructures();
    if (_searchQuery.isEmpty) {
      return structures;
    }
    final query = _searchQuery.toLowerCase();
    return structures.where((structure) => structure.structureName.toLowerCase().contains(query)).toList();
  }

  bool get _isLoading {
    if (widget.enterpriseId != null) {
      final enterpriseState = ref.watch(enterpriseOrgStructureNotifierProvider(widget.enterpriseId!));
      return enterpriseState.isLoading;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final filteredStructures = _filteredStructures;
    final isLoading = _isLoading;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 550.w,
          constraints: BoxConstraints(maxHeight: 650.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(child: _buildContent(context, filteredStructures, isLoading)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        border: Border(bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.2), width: 1)),
      ),
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
                child: Icon(Icons.account_tree_rounded, color: AppColors.primary, size: 24.sp),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Organizational Structure',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Gap(2.h),
                    Text(
                      'Choose a structure from the list',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close_rounded, size: 24.sp),
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ],
          ),
          Gap(16.h),
          SearchField(
            hintText: 'Search structures...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
            initialValue: _searchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<OrgStructure> structures, bool isLoading) {
    if (isLoading && structures.isEmpty) {
      return _buildLoadingSkeleton();
    }

    if (structures.isEmpty && !isLoading) {
      return const OrgUnitSelectionEmptyState(message: 'No structures found');
    }

    final shouldShowSelection = !isLoading && structures.isNotEmpty;

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: structures.length + (isLoading ? 3 : 0),
      separatorBuilder: (context, index) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index >= structures.length) {
          return _buildStructureListItemSkeleton();
        }

        final structure = structures[index];
        final isSelected = shouldShowSelection && widget.selectedStructure?.structureId == structure.structureId;

        return _buildStructureListItem(context, structure, isSelected);
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 6,
        separatorBuilder: (context, index) => Gap(8.h),
        itemBuilder: (context, index) {
          return _buildStructureListItemSkeleton();
        },
      ),
    );
  }

  Widget _buildStructureListItemSkeleton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8.r)),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
                Gap(8.h),
                Container(
                  width: 200.w,
                  height: 12.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStructureListItem(BuildContext context, OrgStructure structure, bool isSelected) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(structure),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderGrey, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.account_tree_rounded,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 20.sp,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    structure.structureName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (structure.description != null && structure.description!.isNotEmpty) ...[
                    Gap(4.h),
                    Text(
                      structure.description!,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
