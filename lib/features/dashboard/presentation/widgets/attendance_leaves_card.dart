import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:grc/features/dashboard/presentation/providers/dashboard_provider.dart';

class AttendanceLeavesCard extends ConsumerWidget {
  final AppLocalizations localizations;
  final VoidCallback? onEyeIconTap;

  const AttendanceLeavesCard({super.key, required this.localizations, this.onEyeIconTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMinimized = ref.watch(attendanceMinimizedProvider);

    final cardPadding = context.responsiveFine(
      mobile: 16.0.w,
      tabletSmall: 16.0.w,
      tabletMedium: 14.0.w,
      tabletLarge: 14.0.w,
      desktop: 14.0.w,
    );
    final sectionSpacing = context.responsive(mobile: 10.0.h, desktop: 7.0.h);
    final itemSpacing = context.responsive(mobile: 9.0.h, desktop: 7.0.h);
    final labelFontSize = context.responsive(mobile: 10.0.sp, desktop: 9.0.sp);

    return Container(
      padding: EdgeInsetsDirectional.all(cardPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.25.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: DigifyAsset(
                        assetPath: Assets.icons.attendanceIcon.path,
                        width: 14,
                        height: 14,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                    const Gap(7),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations.attendanceLeaves,
                          style: context.labelMedium.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF101828),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: Icon(isMinimized ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded, color: const Color(0xFF667085)),
                    onPressed: () => ref.read(attendanceMinimizedProvider.notifier).state = !isMinimized,
                  ),
                  const Gap(3.5),
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: DigifyAsset(
                      assetPath: Assets.icons.eyesIcon.path,
                      width: 14,
                      height: 14,
                      color: const Color(0xFF667085),
                    ),
                    onPressed: () => ref.read(attendanceMinimizedProvider.notifier).state = !isMinimized,
                  ),
                ],
              ),
            ],
          ),

          if (!isMinimized) ...[
            Gap(sectionSpacing),

            Text(
              localizations.todaysAttendance,
              style: context.labelSmall.copyWith(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF667085),
              ),
            ),

            Gap(itemSpacing),
            Container(
              padding: EdgeInsetsDirectional.all(8.w),
              decoration: BoxDecoration(color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.25.w),
                    decoration: BoxDecoration(color: const Color(0xFF0284C7), shape: BoxShape.circle),
                    child: DigifyAsset(
                      assetPath: Assets.icons.checkIconGreen.path,
                      width: 14,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check In: 08:45 AM',
                          style: context.labelSmall.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const Gap(2),
                        Text(
                          'Status: ${localizations.statusOnTime}',
                          style: context.bodySmall.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 1.75.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'Active',
                      style: context.labelSmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Gap(sectionSpacing),
            Text(
              localizations.myUpcomingLeaves,
              style: context.labelSmall.copyWith(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF667085),
              ),
            ),

            Gap(itemSpacing),
            Container(
              padding: EdgeInsetsDirectional.all(8.w),
              decoration: BoxDecoration(color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.25.w),
                    decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(7.r)),
                    child: DigifyAsset(
                      assetPath: Assets.icons.calendarIcon.path,
                      width: 14,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                  Gap(10.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.annualLeave,
                          style: context.labelSmall.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const Gap(2),
                        Text(
                          'Dec 28-25 (5\ndays)',
                          style: context.bodySmall.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 1.75.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'Approved',
                      style: context.labelSmall.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Gap(sectionSpacing),
            Text(
              localizations.teamOnLeaveToday,
              style: context.labelSmall.copyWith(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF667085),
              ),
            ),

            Gap(itemSpacing),
            _buildTeamMemberItem(context, 'AH', 'Ahmad Hassan', localizations.sickLeave, const Color(0xFF0284C7)),
            Gap(itemSpacing),
            _buildTeamMemberItem(context, 'MK', 'Mohammed Khan', localizations.emergencyLeave, const Color(0xFF0284C7)),

            Gap(15.h),
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  localizations.viewFullCalendar,
                  style: context.labelSmall.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamMemberItem(BuildContext context, String initials, String name, String leaveType, Color avatarColor) {
    final primaryTextColor = context.themeTextPrimary;
    final tertiaryTextColor = context.themeTextTertiary;

    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: context.labelSmall.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
        const Gap(7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: context.labelSmall.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor,
                ),
              ),
              const Gap(2),
              Text(
                leaveType,
                style: context.bodySmall.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tertiaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
