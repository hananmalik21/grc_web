import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_mobile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkSchedulesList extends StatelessWidget {
  final List<WorkScheduleItem> schedules;
  final Function(WorkScheduleItem) onViewDetails;
  final Function(WorkScheduleItem) onEdit;
  final Function(WorkScheduleItem) onDelete;
  final Set<int> deletingScheduleIds;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool paginationIsLoading;

  const WorkSchedulesList({
    super.key,
    required this.schedules,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.deletingScheduleIds = const {},
    this.paginationInfo,
    required this.currentPage,
    required this.pageSize,
    this.onPrevious,
    this.onNext,
    this.paginationIsLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = context.screenLayout.isMobile;

    final List<Widget> children = schedules
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final schedule = entry.value;
          final isDeleting = deletingScheduleIds.contains(schedule.workScheduleId);
          final card = isMobile
              ? WorkScheduleMobileCard(
                  title: schedule.title,
                  titleArabic: schedule.titleArabic,
                  code: schedule.code,
                  isActive: schedule.isActive,
                  effectiveStartDate: schedule.effectiveStartDate,
                  effectiveEndDate: schedule.effectiveEndDate,
                  onViewDetails: () => onViewDetails(schedule),
                  onEdit: () => onEdit(schedule),
                  onDelete: () => onDelete(schedule),
                  isDeleting: isDeleting,
                )
              : WorkScheduleCard(
                  title: schedule.title,
                  titleArabic: schedule.titleArabic,
                  year: schedule.year,
                  code: schedule.code,
                  isActive: schedule.isActive,
                  workPatternName: schedule.workPatternName,
                  assignmentMode: schedule.assignmentMode,
                  effectiveStartDate: schedule.effectiveStartDate,
                  effectiveEndDate: schedule.effectiveEndDate,
                  weeklySchedule: schedule.weeklySchedule,
                  onViewDetails: () => onViewDetails(schedule),
                  onEdit: () => onEdit(schedule),
                  onDelete: () => onDelete(schedule),
                  isDeleting: isDeleting,
                );
          return Column(children: [card, if (index < schedules.length - 1) Gap(12.h)]);
        })
        .cast<Widget>()
        .toList();

    if (paginationInfo != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: PaginationControls(
            currentPage: currentPage,
            totalPages: paginationInfo!.totalPages,
            totalItems: paginationInfo!.totalItems,
            pageSize: pageSize,
            hasNext: paginationInfo!.hasNext,
            hasPrevious: paginationInfo!.hasPrevious,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ),
      );
    }

    return Column(children: children.toList());
  }
}

class WorkScheduleItem {
  final String title;
  final String? titleArabic;
  final String year;
  final String code;
  final bool isActive;
  final String workPatternName;
  final String assignmentMode;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final Map<String, String> weeklySchedule;
  final int workScheduleId;

  const WorkScheduleItem({
    required this.title,
    this.titleArabic,
    required this.year,
    required this.code,
    required this.isActive,
    required this.workPatternName,
    required this.assignmentMode,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.weeklySchedule,
    required this.workScheduleId,
  });
}
