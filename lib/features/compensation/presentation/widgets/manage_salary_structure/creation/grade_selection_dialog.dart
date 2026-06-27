import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_scope_selection_providers.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/grade_list_item.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryStructureGradeSelectionDialog extends ConsumerStatefulWidget {
  final Grade? selectedGrade;

  const SalaryStructureGradeSelectionDialog({super.key, this.selectedGrade});

  static Future<Grade?> show({required BuildContext context, Grade? selectedGrade}) async {
    return showDialog<Grade>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SalaryStructureGradeSelectionDialog(selectedGrade: selectedGrade),
    );
  }

  @override
  ConsumerState<SalaryStructureGradeSelectionDialog> createState() => _SalaryStructureGradeSelectionDialogState();
}

class _SalaryStructureGradeSelectionDialogState extends ConsumerState<SalaryStructureGradeSelectionDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(salaryStructureGradeNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salaryStructureGradeNotifierProvider);
    final items = state.items;
    final isLoading = state.isLoading;
    final errorMessage = state.errorMessage;
    final isLoadingMore = state.isLoadingMore;

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
              Flexible(child: _buildContent(context, items, isLoading, errorMessage, isLoadingMore)),
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
                child: Icon(Icons.grade_rounded, color: AppColors.primary, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Grade',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Choose a grade from the list',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
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
            hintText: 'Search grades...',
            onChanged: (value) => ref.read(salaryStructureGradeNotifierProvider.notifier).search(value),
            onClear: () => ref.read(salaryStructureGradeNotifierProvider.notifier).clearSearch(),
            initialValue: ref.read(salaryStructureGradeNotifierProvider).searchQuery ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Grade> items, bool isLoading, String? error, bool isLoadingMore) {
    if (isLoading && items.isEmpty) return const OrgUnitSelectionSkeleton();
    if (error != null && items.isEmpty) {
      return OrgUnitSelectionErrorState(
        error: error,
        onRetry: () => ref.read(salaryStructureGradeNotifierProvider.notifier).refresh(),
      );
    }
    if (items.isEmpty) return const OrgUnitSelectionEmptyState(message: 'No Grades found');

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
            ),
          );
        }

        final grade = items[index];
        final isSelected = widget.selectedGrade?.id == grade.id;
        return GradeListItem(grade: grade, isSelected: isSelected, onTap: () => context.pop(grade));
      },
    );
  }
}
