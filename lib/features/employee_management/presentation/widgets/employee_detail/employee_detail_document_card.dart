import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailDocumentCard extends StatelessWidget {
  const EmployeeDetailDocumentCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.statusLabel,
    required this.number,
    required this.expiryDate,
    required this.isDark,
    this.firstFieldLabel = 'Number',
    this.accessUrl,
  });

  final String title;
  final String iconPath;
  final String statusLabel;
  final String number;
  final String expiryDate;
  final bool isDark;
  final String firstFieldLabel;
  final String? accessUrl;

  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.infoBorderDark : AppColors.dashboardCardBorder;
    final iconBg = isDark ? AppColors.infoBgDark : AppColors.infoBg;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: _borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: iconPath, width: 22.w, height: 22.h, color: AppColors.primary),
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
                ),
              ),
              DigifyCapsule(
                label: statusLabel,
                backgroundColor: isDark ? AppColors.successBgDark : AppColors.successBg,
                textColor: isDark ? AppColors.successTextDark : AppColors.successText,
              ),
            ],
          ),
          Gap(20.h),
          Text(
            firstFieldLabel,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          Gap(4.h),
          Text(
            number,
            style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
          Gap(8.h),
          Text(
            'Expiry Date',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          Gap(4.h),
          Text(
            expiryDate,
            style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
          if (accessUrl != null && accessUrl!.trim().isNotEmpty) ...[
            Gap(16.h),
            Divider(height: 1.h, color: borderColor, thickness: 1),
            Gap(12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final uri = Uri.tryParse(accessUrl!);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                      border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.download_rounded, size: 18.sp, color: AppColors.primary),
                        Gap(8.w),
                        Text(
                          'Download',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
