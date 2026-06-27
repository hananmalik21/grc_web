import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'application_detail_section.dart';

class ApplicationRequisitionCard extends StatelessWidget {
  const ApplicationRequisitionCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return ApplicationDetailSection(
      title: 'Requisition',
      actionLabel: 'View Details',
      onActionPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.requisitionTitle,
            style: context.textTheme.titleSmall?.copyWith(color: primaryText, fontSize: 15.sp),
          ),
          Gap(4.h),
          Row(
            children: [
              Text(detail.requisitionNumber, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
              Gap(8.w),
              DigifyStatusDot(color: secondaryText, size: 4),
              Gap(8.w),
              Expanded(
                child: Text(
                  detail.postingTitle,
                  style: context.textTheme.bodyMedium?.copyWith(color: secondaryText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
