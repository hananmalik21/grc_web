import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ManagerActionRecommendationsSection extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const ManagerActionRecommendationsSection({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(22.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E3A8A), const Color(0xFF1E293B)]
              : [const Color(0xFFEFF6FF), const Color(0xFFEEF2FF)],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ),
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: const Color(0xFFBEDBFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 17.5.sp, color: isDark ? AppColors.infoTextDark : AppColors.infoText),
              Gap(7.w),
              Text(
                localizations.managerActionRecommendations,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                  height: 21 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Row(
            children: [
              Expanded(
                child: _RecommendationCard(
                  title: localizations.encourageLeavePlanning,
                  description: localizations.encourageLeavePlanningDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _RecommendationCard(
                  title: localizations.approvePendingRequests,
                  description: localizations.approvePendingRequestsDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _RecommendationCard(
                  title: localizations.encashmentOption,
                  description: localizations.encashmentOptionDescription,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isDark;

  const _RecommendationCard({required this.title, required this.description, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              height: 21 / 13.7,
              letterSpacing: 0,
            ),
          ),
          Gap(7.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
              height: 17.5 / 12.1,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
