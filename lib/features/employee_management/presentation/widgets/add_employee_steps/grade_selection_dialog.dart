import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeSelectionDialog extends ConsumerStatefulWidget {
  const GradeSelectionDialog({super.key, required this.enterpriseId, this.selectedGrade});

  final int enterpriseId;
  final Grade? selectedGrade;

  static Future<Grade?> show(BuildContext context, {required int enterpriseId, Grade? selectedGrade}) async {
    return showDialog<Grade>(
      context: context,
      barrierDismissible: false,
      builder: (context) => GradeSelectionDialog(enterpriseId: enterpriseId, selectedGrade: selectedGrade),
    );
  }

  @override
  ConsumerState<GradeSelectionDialog> createState() => _GradeSelectionDialogState();
}

class _GradeSelectionDialogState extends ConsumerState<GradeSelectionDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeGradeNotifierProvider(widget.enterpriseId).notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeGradeNotifierProvider(widget.enterpriseId));
    final notifier = ref.read(employeeGradeNotifierProvider(widget.enterpriseId).notifier);

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
            mainAxisSize: MainAxisSize.min,
            children: [
              OrgUnitSelectionHeader(
                levelName: 'Grade',
                onClose: () => context.pop<Grade?>(widget.selectedGrade),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    notifier.clearSearch();
                  } else {
                    notifier.search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedGrade != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<Grade?>(null),
                    ),
                  ),
                ),
              Flexible(child: _buildList(state)),
              PaginationControls(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                hasNext: state.hasNextPage,
                hasPrevious: state.hasPreviousPage,
                isLoading: false,
                onPrevious: () => notifier.goToPage(state.currentPage - 1),
                onNext: () => notifier.goToPage(state.currentPage + 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(dynamic state) {
    if (state.isLoading && state.items.isEmpty) {
      return const OrgUnitSelectionSkeleton();
    }
    if (state.hasError && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load grades',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final items = state.items as List<Grade>;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No grades found',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: items.length,
      separatorBuilder: (_, _) => Gap(8.h),
      itemBuilder: (context, index) {
        final grade = items[index];
        return SelectionListItem(
          title: grade.gradeLabel,
          subtitle: grade.gradeCategoryLabel,
          isSelected: widget.selectedGrade != null && widget.selectedGrade!.id == grade.id,
          onTap: () => context.pop(grade),
        );
      },
    );
  }
}
