import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

class CyberComplianceBars extends StatelessWidget {
  const CyberComplianceBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FRAMEWORK COMPLIANCE',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(16),
          _buildFrameworkRow(
            label: 'NIST CSF',
            percentage: 0.72,
            barColor: AppColors.dashCyberSecurity,
          ),
          const Gap(12),
          _buildFrameworkRow(
            label: 'CIS v8',
            percentage: 0.80,
            barColor: AppColors.primaryLight,
          ),
          const Gap(12),
          _buildFrameworkRow(
            label: 'ISO 27001',
            percentage: 0.68,
            barColor: AppColors.barPurple,
          ),
          const Gap(12),
          _buildFrameworkRow(
            label: 'SOC 2',
            percentage: 0.85,
            barColor: AppColors.cyberLiveGreen,
          ),
          const Gap(12),
          _buildFrameworkRow(
            label: 'CSA CCM',
            percentage: 0.62,
            barColor: AppColors.cyberMedium,
          ),
          const Gap(14),
          Row(
            children: [
              SizedBox(width: 56.w),
              const Gap(8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAxisLabel('0%'),
                    _buildAxisLabel('25%'),
                    _buildAxisLabel('50%'),
                    _buildAxisLabel('75%'),
                    _buildAxisLabel('100%'),
                  ],
                ),
              ),
              SizedBox(width: 38.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAxisLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPlaceholderDark,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildFrameworkRow({
    required String label,
    required double percentage,
    required Color barColor,
  }) {
    final pctInt = (percentage * 100).toInt();

    return Row(
      children: [
        SizedBox(
          width: 56.w,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.r),
            child: Container(
              height: 12.h,
              color: AppColors.cardBackgroundGreyDark,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        SizedBox(
          width: 30.w,
          child: Text(
            '$pctInt%',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
