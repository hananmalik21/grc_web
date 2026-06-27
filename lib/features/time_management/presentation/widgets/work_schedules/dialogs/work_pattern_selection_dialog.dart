import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_pattern_list_item.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/search_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class WorkPatternSelectionDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkPattern? selectedWorkPattern;

  const WorkPatternSelectionDialog({super.key, required this.enterpriseId, this.selectedWorkPattern});

  static Future<WorkPattern?> show({
    required BuildContext context,
    required int enterpriseId,
    WorkPattern? selectedWorkPattern,
  }) async {
    return await showDialog<WorkPattern>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          WorkPatternSelectionDialog(enterpriseId: enterpriseId, selectedWorkPattern: selectedWorkPattern),
    );
  }

  @override
  ConsumerState<WorkPatternSelectionDialog> createState() => _WorkPatternSelectionDialogState();
}

class _WorkPatternSelectionDialogState extends ConsumerState<WorkPatternSelectionDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier);
      notifier.setEnterpriseId(widget.enterpriseId);
      notifier.reset();
      await notifier.loadFirstPage();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final workPatternsState = ref.watch(workPatternsNotifierProvider(widget.enterpriseId));
    final items = workPatternsState.items;
    final isLoading = workPatternsState.isLoading;
    final errorMessage = workPatternsState.errorMessage;
    final isLoadingMore = workPatternsState.isLoadingMore;

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
                child: Icon(Icons.schedule, color: AppColors.primary, size: 24.sp),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Work Pattern',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Gap(2.h),
                    Text(
                      'Choose a work pattern from the list',
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
            hintText: 'Search work patterns...',
            onChanged: (value) {
              ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier).refresh();
            },
            onClear: () {
              ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier).refresh();
            },
            initialValue: '',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<WorkPattern> items,
    bool isLoading,
    String? error,
    bool isLoadingMore,
  ) {
    if (isLoading && items.isEmpty) {
      return const OrgUnitSelectionSkeleton();
    }

    if (error != null && items.isEmpty) {
      return OrgUnitSelectionErrorState(
        error: error,
        onRetry: () => ref.read(workPatternsNotifierProvider(widget.enterpriseId).notifier).refresh(),
      );
    }

    if (items.isEmpty) {
      return const TimeManagementEmptyStateWidget(message: 'No Work Patterns found');
    }

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
              child: AppLoadingIndicator(size: 24.w),
            ),
          );
        }

        final workPattern = items[index];
        final isSelected = widget.selectedWorkPattern?.workPatternId == workPattern.workPatternId;

        return WorkPatternListItem(
          workPattern: workPattern,
          isSelected: isSelected,
          onTap: () => context.pop(workPattern),
        );
      },
    );
  }
}
