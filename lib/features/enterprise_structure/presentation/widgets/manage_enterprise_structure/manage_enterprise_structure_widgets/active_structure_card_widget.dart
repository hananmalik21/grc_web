import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Active structure card widget
class ActiveStructureCardWidget extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const ActiveStructureCardWidget({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(14.w),
        web: EdgeInsetsDirectional.all(17.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
        border: Border.all(color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF), width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.infoIconGreen.path,
                      width: 20,
                      height: 20,
                      color: isDark ? AppColors.successTextDark : const Color(0xFF0D542B),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        localizations.currentlyActiveStructure,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.successTextDark : const Color(0xFF0D542B),
                          height: 24 / 15.6,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Text(
                        localizations.active,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 16 / 11.8,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text.rich(
                  TextSpan(
                    text: localizations.standardKuwaitCorporateStructure,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                      height: 24 / 15.4,
                      letterSpacing: 0,
                    ),
                    children: [
                      TextSpan(
                        text: ' - ${localizations.traditionalHierarchicalStructure}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    Text(
                      '5 ${localizations.activeLevels}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                        height: 20 / 13.5,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '58 ${localizations.components}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                        height: 20 / 13.7,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '450 ${localizations.employees}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                        height: 20 / 13.7,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 2.h),
                  child: DigifyAsset(
                    assetPath: Assets.icons.infoIconGreen.path,
                    width: isTablet ? 22 : 24,
                    height: isTablet ? 22 : 24,
                    color: isDark ? AppColors.successTextDark : const Color(0xFF0D542B),
                  ),
                ),
                SizedBox(width: isTablet ? 10.w : 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            localizations.currentlyActiveStructure,
                            style: TextStyle(
                              fontSize: isTablet ? 14.5.sp : 15.6.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF0D542B),
                              height: 24 / 15.6,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: isTablet ? 10.w : 12.w),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 10.w : 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A63E),
                              borderRadius: BorderRadius.circular(9999.r),
                            ),
                            child: Text(
                              localizations.active,
                              style: TextStyle(
                                fontSize: isTablet ? 11.sp : 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 16 / 11.8,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text.rich(
                        TextSpan(
                          text: localizations.standardKuwaitCorporateStructure,
                          style: TextStyle(
                            fontSize: isTablet ? 14.5.sp : 15.4.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                            height: 24 / 15.4,
                            letterSpacing: 0,
                          ),
                          children: [
                            TextSpan(
                              text: ' - ${localizations.traditionalHierarchicalStructure}',
                              style: TextStyle(
                                fontSize: isTablet ? 14.5.sp : 15.4.sp,
                                fontWeight: FontWeight.w400,
                                color: isDark ? AppColors.successTextDark : const Color(0xFF016630),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: isTablet ? 12.w : 16.w,
                        runSpacing: 4.h,
                        children: [
                          Text(
                            '5 ${localizations.activeLevels}',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 13.5.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                              height: 20 / 13.5,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 14.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            '58 ${localizations.components}',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 13.7.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                              height: 20 / 13.7,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 14.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            '450 ${localizations.employees}',
                            style: TextStyle(
                              fontSize: isTablet ? 12.5.sp : 13.7.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                              height: 20 / 13.7,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
