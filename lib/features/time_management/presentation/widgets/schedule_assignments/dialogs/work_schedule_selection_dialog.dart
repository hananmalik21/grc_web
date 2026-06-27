import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/work_schedule_list_item.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/search_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class WorkScheduleSelectionDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final int? selectedScheduleId;

  const WorkScheduleSelectionDialog({
    super.key,
    required this.enterpriseId,
    this.selectedScheduleId,
  });

  static Future<WorkSchedule?> show({
    required BuildContext context,
    required int enterpriseId,
    int? selectedScheduleId,
  }) async {
    return await showDialog<WorkSchedule>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WorkScheduleSelectionDialog(
        enterpriseId: enterpriseId,
        selectedScheduleId: selectedScheduleId,
      ),
    );
  }

  @override
  ConsumerState<WorkScheduleSelectionDialog> createState() =>
      _WorkScheduleSelectionDialogState();
}

class _WorkScheduleSelectionDialogState
    extends ConsumerState<WorkScheduleSelectionDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(
        workSchedulesNotifierProvider(widget.enterpriseId).notifier,
      );
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref
          .read(workSchedulesNotifierProvider(widget.enterpriseId).notifier)
          .loadNextPage();
    }
  }

  List<WorkSchedule> _filterSchedules(
    List<WorkSchedule> schedules,
    String? searchQuery,
  ) {
    if (searchQuery == null || searchQuery.isEmpty) {
      return schedules;
    }
    final query = searchQuery.toLowerCase();
    return schedules.where((schedule) {
      return schedule.scheduleNameEn.toLowerCase().contains(query) ||
          schedule.scheduleNameAr.toLowerCase().contains(query) ||
          schedule.scheduleCode.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final schedulesState = ref.watch(
      workSchedulesNotifierProvider(widget.enterpriseId),
    );
    final allActiveItems = schedulesState.items
        .where((s) => s.isActive)
        .toList();
    final items = _filterSchedules(allActiveItems, schedulesState.searchQuery);
    final isLoading = schedulesState.isLoading;
    final errorMessage = schedulesState.errorMessage;
    final isLoadingMore = schedulesState.isLoadingMore;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 8,
        child: Container(
          width: 550.w,
          constraints: BoxConstraints(maxHeight: 650.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: _buildContent(
                  context,
                  items,
                  isLoading,
                  errorMessage,
                  isLoadingMore,
                ),
              ),
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
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
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
                child: Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Work Schedule',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'Choose a work schedule from the list',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          Gap(16.h),
          SearchField(
            hintText: 'Search work schedules...',
            onChanged: (value) {
              ref
                  .read(
                    workSchedulesNotifierProvider(widget.enterpriseId).notifier,
                  )
                  .search(value);
            },
            onClear: () {
              ref
                  .read(
                    workSchedulesNotifierProvider(widget.enterpriseId).notifier,
                  )
                  .search('');
            },
            initialValue:
                ref
                    .read(workSchedulesNotifierProvider(widget.enterpriseId))
                    .searchQuery ??
                '',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<WorkSchedule> items,
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
        onRetry: () => ref
            .read(workSchedulesNotifierProvider(widget.enterpriseId).notifier)
            .refresh(),
      );
    }

    if (items.isEmpty) {
      return const TimeManagementEmptyStateWidget(
        message: 'No Work Schedules found',
      );
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

        final schedule = items[index];
        final isSelected = widget.selectedScheduleId == schedule.workScheduleId;

        return WorkScheduleListItem(
          schedule: schedule,
          isSelected: isSelected,
          onTap: () => context.pop(schedule),
        );
      },
    );
  }
}
