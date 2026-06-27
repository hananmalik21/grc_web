import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_content.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleCard extends StatelessWidget {
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
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const WorkScheduleCard({
    super.key,
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
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final padding = ResponsiveHelper.getCardPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkScheduleCardHeader(title: title, titleArabic: titleArabic, year: year, code: code, isActive: isActive),
            Gap(16.h),
            WorkScheduleCardContent(
              workPatternName: workPatternName,
              assignmentMode: assignmentMode,
              effectiveStartDate: effectiveStartDate,
              effectiveEndDate: effectiveEndDate,
              weeklySchedule: weeklySchedule,
            ),
            DigifyDivider(margin: EdgeInsets.symmetric(vertical: 16.h)),
            WorkScheduleCardActions(
              onViewDetails: onViewDetails,
              onEdit: onEdit,
              onDelete: onDelete,
              isDeleting: isDeleting,
            ),
          ],
        ),
      ),
    );
  }
}
