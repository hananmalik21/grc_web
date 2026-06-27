import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelSelectionDialog extends ConsumerStatefulWidget {
  const JobLevelSelectionDialog({super.key, required this.enterpriseId, this.selectedJobLevel});

  final int enterpriseId;
  final JobLevel? selectedJobLevel;

  static Future<JobLevel?> show(BuildContext context, {required int enterpriseId, JobLevel? selectedJobLevel}) async {
    return showDialog<JobLevel>(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobLevelSelectionDialog(enterpriseId: enterpriseId, selectedJobLevel: selectedJobLevel),
    );
  }

  @override
  ConsumerState<JobLevelSelectionDialog> createState() => _JobLevelSelectionDialogState();
}

class _JobLevelSelectionDialogState extends ConsumerState<JobLevelSelectionDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeJobLevelNotifierProvider(widget.enterpriseId).notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeJobLevelNotifierProvider(widget.enterpriseId));
    final notifier = ref.read(employeeJobLevelNotifierProvider(widget.enterpriseId).notifier);

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
                levelName: 'Job Level',
                onClose: () => context.pop<JobLevel?>(widget.selectedJobLevel),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    notifier.clearSearch();
                  } else {
                    notifier.search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedJobLevel != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<JobLevel?>(null),
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
            state.errorMessage ?? 'Failed to load job levels',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final items = state.items as List<JobLevel>;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No job levels found',
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
        final jobLevel = items[index];
        return SelectionListItem(
          title: jobLevel.nameEn,
          subtitle: jobLevel.code,
          isSelected: widget.selectedJobLevel != null && widget.selectedJobLevel!.id == jobLevel.id,
          onTap: () => context.pop(jobLevel),
        );
      },
    );
  }
}
