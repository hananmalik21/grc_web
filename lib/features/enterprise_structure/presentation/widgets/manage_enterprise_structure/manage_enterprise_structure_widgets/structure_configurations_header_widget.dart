import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/enterprise_structure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Structure configurations header widget
class StructureConfigurationsHeaderWidget extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;

  const StructureConfigurationsHeaderWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.structureListProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(14.w),
        web: EdgeInsetsDirectional.all(16.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.structureConfigurations,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 24 / 15.6,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.manageDifferentConfigurations,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                    height: 20 / 13.6,
                    letterSpacing: 0,
                  ),
                ),
                // SizedBox(height: 4.h),
                // Text(
                //   "💡 Create multiple structures for different business units or use cases",
                //   style: TextStyle(
                //     fontSize: isTablet ? 12.5.sp : 10.6.sp,
                //     fontWeight: FontWeight.w400,
                //     color: Color(0xFF155DFC),
                //     height: 20 / 13.6,
                //     letterSpacing: 0,
                //   ),
                // ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    EnterpriseStructureDialog.showCreate(context, provider: structureListProvider);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF155DFC),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.createNewStructureIcon.path,
                          width: 18,
                          height: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          localizations.createNewStructure,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 24 / 15.3,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        localizations.structureConfigurations,
                        style: TextStyle(
                          fontSize: isTablet ? 14.5.sp : 15.6.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                          height: 24 / 15.6,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        localizations.manageDifferentConfigurations,
                        style: TextStyle(
                          fontSize: isTablet ? 12.5.sp : 13.6.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                          height: 20 / 13.6,
                          letterSpacing: 0,
                        ),
                      ),
                      // SizedBox(height: 4.h),
                      // Text(
                      //   "💡 Create multiple structures for different business units or use cases",
                      //   style: TextStyle(
                      //     fontSize: isTablet ? 12.5.sp : 10.6.sp,
                      //     fontWeight: FontWeight.w400,
                      //     color: Color(0xFF155DFC),
                      //     height: 20 / 13.6,
                      //     letterSpacing: 0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 12.w : 16.w),
                GestureDetector(
                  onTap: () {
                    EnterpriseStructureDialog.showCreate(context, provider: structureListProvider);
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 20.w : 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF155DFC),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.createNewStructureIcon.path,
                          width: isTablet ? 18 : 20,
                          height: isTablet ? 18 : 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          localizations.createNewStructure,
                          style: TextStyle(
                            fontSize: isTablet ? 14.sp : 15.3.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 24 / 15.3,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
