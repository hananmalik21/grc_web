import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/enterprise_structure/domain/models/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class DivisionDetailsDialog extends StatelessWidget {
  final DivisionOverview division;

  const DivisionDetailsDialog({super.key, required this.division});

  static Future<void> show(BuildContext context, DivisionOverview division) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => DivisionDetailsDialog(division: division),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          width: 700.w,
          constraints: BoxConstraints(maxHeight: 750.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 50, offset: const Offset(0, 25)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, localizations),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBasicInformation(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildLeadership(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildLocation(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildOrganizationalMetrics(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildDescription(localizations, isDark),
                      ],
                    ),
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
          colors: [Color(0xFF9810FA), Color(0xFF8200DB)],
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
              DigifyAsset(assetPath: Assets.icons.divisionHeaderIcon.path, width: 20, height: 20, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                localizations.divisionDetails,
                style: TextStyle(
                  fontSize: 18.8.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 30 / 18.8,
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

  Widget _buildBasicInformation(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.basicInformation, 'assets/icons/basic_info_division_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildInfoRow('${localizations.divisionCode}:', division.code, isDark),
              SizedBox(height: 8.h),
              _buildInfoRowWithBadge(
                '${localizations.status}:',
                division.isActive ? localizations.active : localizations.inactive,
                division.isActive,
                isDark,
              ),
              SizedBox(height: 8.h),
              _buildInfoRow('${localizations.company}:', division.companyName, isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('${localizations.established}:', division.establishedDate ?? '2010-01-15', isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('${localizations.businessFocus}:', division.industry, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeadership(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.leadership, 'assets/icons/leadership_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildInfoRow('${localizations.headOfDivision}:', division.headName, isDark),
              SizedBox(height: 8.h),
              _buildContactIconRow(
                'assets/icons/email_detail_icon.svg',
                division.headEmail ?? 'ahmed.rashid@kuwaitholdings.com',
                isDark,
              ),
              SizedBox(height: 8.h),
              _buildContactIconRow(
                'assets/icons/phone_detail_icon.svg',
                division.headPhone ?? '+965 2222 3344',
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.location, 'assets/icons/location_section_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _buildLocationContent(isDark),
        ),
      ],
    );
  }

  Widget _buildLocationContent(bool isDark) {
    final locationParts = division.location.split(',');
    final mainLocation = locationParts.isNotEmpty ? locationParts.first.trim() : division.location;
    final address = division.address ?? 'Tower A, 5th Floor, Al-Shuhada Street';
    final city = division.city ?? 'Kuwait City';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: DigifyAsset(
            assetPath: Assets.icons.locationPinIcon.path,
            width: 16,
            height: 16,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainLocation,
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                  height: 24 / 15.3,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                  height: 24 / 15.3,
                ),
              ),
              Text(
                city,
                style: TextStyle(
                  fontSize: 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                  height: 24 / 15.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationalMetrics(AppLocalizations localizations, bool isDark) {
    // Parse budget value
    final budgetStr = division.budget.replaceAll('M', '').replaceAll(' KWD', '');
    final budgetValue = double.tryParse(budgetStr) ?? 0;
    final formattedBudget =
        '${(budgetValue * 1000000).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} KWD';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.organizationalMetrics, 'assets/icons/metrics_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildInfoRow('${localizations.totalEmployees}:', division.employees.toString(), isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('${localizations.totalDepartments}:', division.departments.toString(), isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('${localizations.annualBudget}:', formattedBudget, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.divisionDescription, 'assets/icons/description_section_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            division.description ?? 'Responsible for all financial operations, accounting, and treasury management',
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
              height: 24 / 15.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String iconPath, bool isDark) {
    return Row(
      children: [
        DigifyAsset(
          assetPath: iconPath,
          width: 20,
          height: 20,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.4.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 24 / 15.4,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 24 / 15.3,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.4.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 24 / 15.4,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithBadge(String label, String value, bool isActive, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.4.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 24 / 15.4,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF065F46) : const Color(0xFFDCFCE7))
                : (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: isActive
                  ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF016630))
                  : (isDark ? const Color(0xFFEF4444) : const Color(0xFF991B1B)),
              height: 20 / 13.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactIconRow(String iconPath, String value, bool isDark) {
    return Row(
      children: [
        DigifyAsset(
          assetPath: iconPath,
          width: 16,
          height: 16,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 24 / 15.3,
          ),
        ),
      ],
    );
  }
}
