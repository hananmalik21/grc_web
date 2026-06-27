import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/employee_self_service/presentation/providers/my_payslips/my_payslips_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayslipSummaryStatCard extends StatelessWidget {
  final PayslipSummaryStat stat;

  const PayslipSummaryStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.tableHeaderText),
                ),
                SizedBox(height: 4.h),
                Text(
                  stat.value,
                  style: context.textTheme.headlineSmall?.copyWith(fontSize: 20.sp, color: context.themeTextPrimary),
                ),
              ],
            ),
          ),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: stat.iconPath, width: 20, height: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
