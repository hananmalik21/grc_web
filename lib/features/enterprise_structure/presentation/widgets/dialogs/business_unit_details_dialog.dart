import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class BusinessUnitDetailsDialog extends StatelessWidget {
  final BusinessUnitOverview businessUnit;

  const BusinessUnitDetailsDialog({super.key, required this.businessUnit});

  static Future<void> show(BuildContext context, BusinessUnitOverview businessUnit) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => BusinessUnitDetailsDialog(businessUnit: businessUnit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 760.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 25)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, localizations),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(context, localizations.basicInformation, Assets.icons.businessUnitBasicIcon.path, [
                        _buildInfoRow(localizations.unitCode, businessUnit.code),
                        _buildStatusRow(localizations.status, businessUnit.isActive, isDark),
                        _buildInfoRow(localizations.division, businessUnit.divisionName),
                        _buildInfoRow(localizations.company, businessUnit.companyName),
                        _buildInfoRow(localizations.establishedDate, businessUnit.establishedDate ?? 'N/A'),
                        _buildInfoRow(localizations.businessFocus, businessUnit.focusArea),
                      ]),
                      SizedBox(height: 24.h),
                      _buildSection(context, localizations.leadership, Assets.icons.leadershipIcon.path, [
                        _buildInfoRow('${localizations.headOfUnit}:', businessUnit.headName),
                        SizedBox(height: 8.h),
                        _buildIconRow(
                          context,
                          localizations.headEmail,
                          businessUnit.headEmail ?? localizations.notSpecified,
                          Assets.icons.headEmailIcon.path,
                        ),
                        SizedBox(height: 8.h),
                        _buildIconRow(
                          context,
                          localizations.headPhone,
                          businessUnit.headPhone ?? localizations.notSpecified,
                          Assets.icons.headPhoneIcon.path,
                        ),
                      ]),
                      SizedBox(height: 24.h),
                      _buildSection(context, localizations.organizationalMetrics, Assets.icons.metricsIcon.path, [
                        _buildInfoRow(localizations.totalEmployees, '${businessUnit.employees}'),
                        _buildInfoRow(localizations.totalDepartments, '${businessUnit.departments}'),
                        _buildInfoRow(localizations.annualBudget, '${businessUnit.budget} KWD'.replaceAll('M M', 'M')),
                      ]),
                      SizedBox(height: 24.h),
                      _buildSection(context, localizations.description, Assets.icons.descriptionIcon.path, [
                        _buildLongText(businessUnit.description ?? localizations.hintBusinessUnitDescription),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF155DFC), Color(0xFF1447E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.businessUnitDetailsIcon.path,
                width: 20,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.businessUnitDetails,
                style: TextStyle(
                  fontSize: 18.6.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 30 / 18.6,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: DigifyAsset(
                assetPath: Assets.icons.closeDialogIcon.path,
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String iconPath, List<Widget> children) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: context.themeTextPrimary),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.4.sp,
                fontWeight: FontWeight.w400,
                color: context.themeTextPrimary,
                height: 24 / 15.4,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4A5565),
              height: 24 / 15.3,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF101828),
                height: 24 / 15.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isActive, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4A5565),
              height: 24 / 15.3,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: isActive ? const Color(0xFF016630) : const Color(0xFF991B1B),
                height: 20 / 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconRow(BuildContext context, String label, String value, String iconPath) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: context.themeTextSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: TextStyle(
                  fontSize: 13.9.sp,
                  fontWeight: FontWeight.w500,
                  color: context.themeTextSecondary,
                  height: 20 / 13.9,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.2.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF101828),
                  height: 20 / 15.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLongText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15.3.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF364153),
        height: 24 / 15.3,
      ),
    );
  }
}
