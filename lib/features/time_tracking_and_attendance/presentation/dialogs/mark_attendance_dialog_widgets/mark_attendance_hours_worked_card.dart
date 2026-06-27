import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_text_theme.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceHoursWorkedCard extends StatelessWidget {
  final MarkAttendanceFormState state;

  const MarkAttendanceHoursWorkedCard({super.key, required this.state});

  String _computeHoursWorked() {
    final checkIn = state.checkInTime;
    final checkOut = state.checkOutTime;

    if (checkIn == null || checkOut == null) {
      return '--';
    }

    final checkInMinutes = checkIn.hour * 60 + checkIn.minute;
    final checkOutMinutes = checkOut.hour * 60 + checkOut.minute;
    int durationMinutes = checkOutMinutes - checkInMinutes;
    if (durationMinutes < 0) durationMinutes += 24 * 60;

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (minutes > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${hours}h';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(assetPath: Assets.icons.priceUpItem.path, width: 18.w, height: 18.h, color: AppColors.infoText),
          Gap(8.w),
          Text(
            'Hours Worked: ${_computeHoursWorked()}',
            style: AppTextTheme.lightTextTheme.titleSmall?.copyWith(color: AppColors.infoText),
          ),
        ],
      ),
    );
  }
}
