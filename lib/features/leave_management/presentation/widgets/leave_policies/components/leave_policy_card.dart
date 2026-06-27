import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'dart:ui' as ui;

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePolicyCard extends StatelessWidget {
  final LeavePolicy policy;
  final bool isDark;

  const LeavePolicyCard({super.key, required this.policy, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = isMobile ? 12.w : 16.w;
    final gapSmall = isMobile ? 4.h : 6.h;
    final gapMedium = isMobile ? 6.h : 8.h;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            policy.nameEn,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: isMobile ? 13.sp : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (policy.isKuwaitLaw) ...[
                          Gap(isMobile ? 6.w : 8.w),
                          DigifyCapsule(
                            label: 'Kuwait Law',
                            backgroundColor: AppColors.successBg,
                            textColor: AppColors.successText,
                          ),
                        ],
                      ],
                    ),
                    Gap(2.h),
                    Text(
                      policy.nameAr,
                      textDirection: ui.TextDirection.rtl,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 11.sp : 13.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gap(4.w),
              _buildStatusBadge(policy.status),
            ],
          ),
          Gap(gapMedium),
          Flexible(
            child: Text(
              policy.description.isEmpty ? 'No description provided' : policy.description,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: isMobile ? 10.sp : 11.sp,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(gapMedium),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Entitlement', '${policy.entitlement} Days')),
              Gap(isMobile ? 6.w : 8.w),
              Expanded(child: _buildDetailItem(context, 'Accrual Type', policy.accrualType)),
            ],
          ),
          Gap(gapSmall),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Min Service', '${policy.minService} Year(s)')),
              Gap(isMobile ? 6.w : 8.w),
              Expanded(child: _buildDetailItem(context, 'Advance Notice', '${policy.advanceNotice} Day(s)')),
            ],
          ),
          Gap(gapSmall),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Max Consecutive',
                  policy.maxConsecutiveDays != null ? '${policy.maxConsecutiveDays} Days' : '-',
                ),
              ),
              Gap(isMobile ? 6.w : 8.w),
              Expanded(child: _buildDetailItem(context, 'Gender', policy.genderRestriction ?? 'All')),
            ],
          ),
          Gap(gapMedium),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: isMobile ? 6.w : 7.w,
              children: [
                DigifyCapsule(
                  label: policy.isPaid ? 'Paid' : 'Unpaid',
                  backgroundColor: policy.isPaid ? AppColors.successBg : AppColors.orangeBg,
                  textColor: policy.isPaid ? AppColors.successText : AppColors.orangeText,
                ),
                if (policy.carryoverDays != null && policy.carryoverDays! > 0)
                  DigifyCapsule(
                    label: 'Carryover: ${policy.carryoverDays} days',
                    backgroundColor: AppColors.jobRoleBg,
                    textColor: AppColors.permissionBadgeText,
                  ),
                if (policy.requiresAttachment)
                  DigifyCapsule(
                    label: 'Attachment Required',
                    backgroundColor: AppColors.orangeBg,
                    textColor: AppColors.orangeText,
                  ),
                if (policy.allowEncashment)
                  DigifyCapsule(
                    label: 'Encashment Allowed',
                    backgroundColor: AppColors.purpleBg,
                    textColor: AppColors.statIconPurple,
                  ),
                if (policy.probationAllowed)
                  DigifyCapsule(
                    label: 'Available in Probation',
                    backgroundColor: AppColors.successBg,
                    textColor: AppColors.successText,
                  ),
                if (policy.countWeekendsAsLeave)
                  DigifyCapsule(
                    label: 'Incl. Weekends',
                    backgroundColor: AppColors.orangeBg,
                    textColor: AppColors.orangeText,
                  ),
                if (policy.countPublicHolidaysAsLeave)
                  DigifyCapsule(
                    label: 'Incl. Holidays',
                    backgroundColor: AppColors.orangeBg,
                    textColor: AppColors.orangeText,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final isActive = status?.toUpperCase() == 'ACTIVE' || status?.toUpperCase() == 'A';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successBg : AppColors.errorBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        isActive ? 'Active' : 'Draft',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.successText : AppColors.errorText,
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final isMobile = context.isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: isMobile ? 11.sp : 12.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(isMobile ? 3.h : 4.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isMobile ? 13.sp : 14.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
