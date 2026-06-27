import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GeofenceStatusCard extends StatelessWidget {
  const GeofenceStatusCard({super.key, required this.geofenceInfo, required this.onOpenMap});

  final TimeAttendanceGeofenceInfo geofenceInfo;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      padding: EdgeInsets.all(21.w),
      title: geofenceInfo.title,
      titleIconPath: Assets.icons.locationSmallIcon.path,
      titleIconColor: AppColors.primary,
      child: Column(
        children: [
          GestureDetector(
            onTap: onOpenMap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                gradient: LinearGradient(
                  colors: [
                    isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
                    isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1.78,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE2E8F0), Color(0xFFF8FAFC)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapGridPainter(lineColor: isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 76.w,
                        height: 76.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.12),
                        ),
                        child: Center(
                          child: Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              border: Border.all(color: AppColors.cardBackground, width: 3.w),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8.w,
                      right: 8.w,
                      bottom: 8.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                geofenceInfo.perimeterLabel,
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              geofenceInfo.badgeLabel,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AppColors.greenTextSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(14.h),
          Row(
            children: [
              Expanded(
                child: _CoordinateCard(label: 'Latitude', value: geofenceInfo.latitude),
              ),
              Gap(10.w),
              Expanded(
                child: _CoordinateCard(label: 'Longitude', value: geofenceInfo.longitude),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoordinateCard extends StatelessWidget {
  const _CoordinateCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
          Gap(4.h),
          Text(value, style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var row = 1; row < 5; row++) {
      final y = size.height * row / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (var column = 1; column < 6; column++) {
      final x = size.width * column / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
