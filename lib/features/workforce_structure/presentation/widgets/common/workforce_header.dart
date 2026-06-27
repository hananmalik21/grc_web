import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';

class WorkforceHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const WorkforceHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF155DFC), Color(0xFF9810FA)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.workforceStructure,
                  style: TextStyle(
                    fontSize: 22.7.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 32 / 22.7,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.managePositionsJobFamilies,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFDBEAFE),
                    height: 24 / 15.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.managePositionsJobFamiliesAr,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFDBEAFE),
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          DigifyAsset(
            assetPath: Assets.icons.workforce.workforceTab.path,
            color: AppColors.background,
          ),
        ],
      ),
    );
  }
}
