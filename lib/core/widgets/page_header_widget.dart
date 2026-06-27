import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header widget for manage enterprise structure screen
class PageHeaderWidget extends StatelessWidget {
  final AppLocalizations localizations;

  const PageHeaderWidget({super.key, required this.localizations, required this.title, required this.icon});

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(color: Color(0xFF155DFC), borderRadius: BorderRadius.circular(10.r)),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 32 / 22.7,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    DigifyAsset(assetPath: icon, width: 24, height: 24, color: Colors.white),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 22.7.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 32 / 22.7,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 12.w : 16.w),
                DigifyAsset(
                  assetPath: icon,
                  width: isTablet ? 28 : 32,
                  height: isTablet ? 28 : 32,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }
}
