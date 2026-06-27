import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_mobile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleAssignmentsMobileContent extends StatelessWidget {
  const ScheduleAssignmentsMobileContent({
    required this.state,
    required this.notifier,
    required this.onDelete,
    required this.onView,
    required this.onEdit,
    super.key,
  });

  final ScheduleAssignmentState state;
  final ScheduleAssignmentsNotifier notifier;
  final ValueChanged<ScheduleAssignment> onDelete;
  final ValueChanged<ScheduleAssignment> onView;
  final ValueChanged<ScheduleAssignment> onEdit;

  @override
  Widget build(BuildContext context) {
    final isInitialLoading = state.isLoading && state.items.isEmpty;
    final assignments = isInitialLoading ? _skeletonAssignments : state.items;

    return Skeletonizer(
      enabled: isInitialLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...assignments.asMap().entries.map((entry) {
            final index = entry.key;
            final assignment = entry.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScheduleAssignmentMobileCard(
                  scheduleName: assignment.workSchedule?.scheduleNameEn ?? 'Morning Shift Schedule',
                  assignedToName: assignment.assignedToName,
                  assignmentLevel: assignment.assignmentLevel,
                  startDate: assignment.formattedStartDate,
                  endDate: assignment.formattedEndDate,
                  isActive: assignment.isActive,
                  isDeleting: state.deletingAssignmentId == assignment.scheduleAssignmentId,
                  onView: () => onView(assignment),
                  onEdit: () => onEdit(assignment),
                  onDelete: () => onDelete(assignment),
                ),
                if (index < assignments.length - 1) Gap(12.h),
              ],
            );
          }),
          if (state.isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (state.totalPages > 0)
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: PaginationControls(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                hasNext: state.hasNextPage,
                hasPrevious: state.hasPreviousPage,
                onPrevious: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
                onNext: state.hasNextPage ? () => notifier.loadNextPage() : null,
              ),
            ),
        ],
      ),
    );
  }

  static final List<ScheduleAssignment> _skeletonAssignments = List.generate(
    3,
    (index) => ScheduleAssignment(
      scheduleAssignmentId: index + 1,
      tenantId: 0,
      assignmentLevel: AssignmentLevel.department,
      workScheduleId: index + 100,
      effectiveStartDate: DateTime(2026, 1, 1),
      effectiveEndDate: DateTime(2026, 12, 31),
      status: 'ACTIVE',
      creationDate: DateTime(2026, 1, 1),
      createdBy: 'SYSTEM',
      lastUpdateDate: DateTime(2026, 1, 1),
      lastUpdatedBy: 'SYSTEM',
      workSchedule: ScheduleAssignmentWorkSchedule(
        workScheduleId: index + 100,
        tenantId: 0,
        scheduleCode: 'SCH-001',
        scheduleNameEn: 'Morning Shift Schedule',
        scheduleNameAr: 'جدول الصباح',
      ),
      orgUnit: const ScheduleAssignmentOrgUnit(
        orgUnitId: '1',
        orgStructureId: '1',
        enterpriseId: 0,
        levelCode: 'DEPARTMENT',
        orgUnitCode: 'DEP-001',
        orgUnitNameEn: 'Operations',
        orgUnitNameAr: 'العمليات',
      ),
    ),
  );
}
