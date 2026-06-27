import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';

enum LocationMethod { currentLocation, markOnMap, sendEmail }

class LocationPickerDialog extends StatefulWidget {
  final String? departmentName;
  final String? departmentCode;
  final String? location;

  const LocationPickerDialog({super.key, this.departmentName, this.departmentCode, this.location});

  static Future<String?> show(
    BuildContext context, {
    String? departmentName,
    String? departmentCode,
    String? location,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          LocationPickerDialog(departmentName: departmentName, departmentCode: departmentCode, location: location),
    );
  }

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  LocationMethod _selectedMethod = LocationMethod.currentLocation;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController(text: '100');
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final bool _locationPermissionDenied = true;

  @override
  void dispose() {
    _emailController.dispose();
    _searchController.dispose();
    _radiusController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        backgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
        child: Container(
          width: isMobile ? double.infinity : 862.w,
          constraints: BoxConstraints(maxHeight: 900.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(isDark, isMobile),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        _buildInfoBanner(isDark),
                        SizedBox(height: 24.h),
                        _buildMethodSelection(isDark, isMobile),
                        SizedBox(height: 24.h),
                        _buildMethodContent(isDark, isMobile),
                        SizedBox(height: 24.h),
                        _buildRadiusSection(isDark, isMobile),
                        SizedBox(height: 24.h),
                        _buildAttendanceInfo(isDark, isMobile),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(isDark, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 18.w : 24.w, 24.h, isMobile ? 18.w : 24.w, 25.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.locationHeaderIcon.path,
                      width: 24,
                      height: 24,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        maxLines: 3,
                        'Set Geo-Location for ${(widget.departmentName ?? "").isNotEmpty ? widget.departmentName : 'Department'}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.6.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                          height: 24 / 15.6,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${widget.departmentName ?? 'Department'} (${widget.departmentCode ?? 'DEPT-AP'})',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                    height: 20 / 13.6,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'قسم الحسابات الدائنة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: '.SF Arabic',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: DigifyAsset(
              assetPath: Assets.icons.closeDialogIcon.path,
              width: 24,
              height: 24,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: DigifyAsset(
              assetPath: Assets.icons.infoCircleBlue.path,
              width: 20,
              height: 20,
              color: isDark ? AppColors.infoTextDark : AppColors.infoText,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configure Google Maps API for Automatic Location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.4.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                    height: 24 / 15.4,
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                      height: 20 / 13.7,
                    ),
                    children: [
                      const TextSpan(
                        text: 'To enable automatic location detection, configure your Google Maps API key in ',
                      ),
                      TextSpan(
                        text: 'Settings & Configurations → API Configuration',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
                      ),
                      const TextSpan(
                        text: '. Alternatively, you can use the "Mark on Map" method to enter coordinates manually.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelection(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Location Method',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 13.7,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: isMobile ? 0 : 16.w,
          runSpacing: 12.h,
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 272.w,
              child: _buildMethodCard(
                method: LocationMethod.currentLocation,
                icon: Assets.icons.mapPinBlue.path,
                title: 'Get Current Location',
                subtitle: 'Use GPS to capture location',
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: isMobile ? double.infinity : 272.w,
              child: _buildMethodCard(
                method: LocationMethod.markOnMap,
                icon: Assets.icons.locationHeaderIcon.path,
                title: 'Mark on Map',
                subtitle: 'Enter coordinates manually',
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: isMobile ? double.infinity : 272.w,
              child: _buildMethodCard(
                method: LocationMethod.sendEmail,
                icon: Assets.icons.emailEnvelopePurple.path,
                title: 'Send Email Request',
                subtitle: 'Ask someone to mark location',
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required LocationMethod method,
    required String icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    final isSelected = _selectedMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.3) : AppColors.infoBg)
              : (isDark ? AppColors.cardBackgroundDark : Colors.transparent),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.infoBorderDark : AppColors.primaryLight)
                : (isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DigifyAsset(
              assetPath: icon,
              width: 24,
              height: 24,
              color: isDark
                  ? (isSelected ? AppColors.infoTextDark : AppColors.textSecondaryDark)
                  : (isSelected ? AppColors.primary : const Color(0xFF4A5565)),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.4.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.4,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                height: 16 / 11.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodContent(bool isDark, bool isMobile) {
    switch (_selectedMethod) {
      case LocationMethod.currentLocation:
        return _buildGetCurrentLocationContent(isDark, isMobile);
      case LocationMethod.markOnMap:
        return _buildMarkOnMapContent(isDark, isMobile);
      case LocationMethod.sendEmail:
        return _buildSendEmailContent(isDark, isMobile);
    }
  }

  Widget _buildGetCurrentLocationContent(bool isDark, bool isMobile) {
    final contentPadding = EdgeInsets.all(isMobile ? 20.r : 25.r);
    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.gpsLocationBlue.path,
                width: 20,
                height: 20,
                color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              ),
              SizedBox(width: 8.w),
              Text(
                'Get Current Location',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                  height: 24 / 15.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Click the button below to automatically capture your current GPS location. Make sure you\'re physically at the department location before capturing.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
              height: 20 / 13.6,
            ),
          ),
          SizedBox(height: 16.h),
          if (_locationPermissionDenied)
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.errorBgDark.withValues(alpha: 0.3) : AppColors.redBg,
                border: Border.all(color: isDark ? AppColors.errorBorderDark : AppColors.redBorder, width: 2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: DigifyAsset(
                      assetPath: Assets.icons.errorCircleRed.path,
                      width: 24,
                      height: 24,
                      color: isDark ? AppColors.errorTextDark : AppColors.redText,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🚫 Location Permission Denied',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.errorTextDark : AppColors.redText,
                            height: 24 / 15.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            'You have blocked location access for this site. To use GPS location, you must enable it in your browser settings.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.6.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.errorTextDark : AppColors.redTextSecondary,
                              height: 20 / 13.6,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.errorBorderDark : AppColors.redButton,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Show Instructions to Enable Location',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.6.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 20 / 13.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: DigifyAsset(assetPath: Assets.icons.locationPinBlue.path, width: 20, height: 20, color: Colors.white),
            label: Text(
              'Get My Current Location',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / 15.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              // padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              elevation: 0,
            ),
          ),
          SizedBox(height: 18.h),
          TextButton.icon(
            onPressed: () {},
            icon: DigifyAsset(
              assetPath: Assets.icons.refreshGray.path,
              width: 16,
              height: 16,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
            ),
            label: Text(
              'Check Permission Status',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                height: 20 / 13.6,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(17.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📱 GPS Accuracy Tips:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 20 / 13.8,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildBulletPoint(
                  'Mobile devices provide the most accurate GPS (typically ±5-15m)',
                  isDark,
                  boldPart: 'Mobile devices',
                ),
                SizedBox(height: 4.h),
                _buildBulletPoint(
                  'Desktop/Laptop may use WiFi triangulation (±50-500m accuracy)',
                  isDark,
                  boldPart: 'Desktop/Laptop',
                ),
                SizedBox(height: 4.h),
                _buildBulletPoint(
                  'IMPORTANT: You must click "Allow" when browser asks for location permission',
                  isDark,
                  boldPart: 'IMPORTANT:',
                ),
                SizedBox(height: 4.h),
                _buildBulletPoint('GPS works better outdoors with clear sky view', isDark),
                SizedBox(height: 4.h),
                _buildBulletPoint('Check the browser console for detailed debug information', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkOnMapContent(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 37.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark.withValues(alpha: 0.2) : AppColors.greenBg,
        border: Border.all(color: isDark ? AppColors.successBorderDark : AppColors.greenBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.mapLocationGreen.path,
                width: 20,
                height: 20,
                color: isDark ? AppColors.successTextDark : AppColors.greenText,
              ),
              SizedBox(width: 8.w),
              Text(
                'Mark Location on Map',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.successTextDark : AppColors.greenText,
                  height: 24 / 15.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Enter the latitude and longitude coordinates manually. You can get these from Google Maps by right-clicking on a location.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.successTextDark : AppColors.greenTextSecondary,
              height: 20 / 13.6,
            ),
          ),
          SizedBox(height: 16.h),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLatitudeField(isDark),
                    SizedBox(height: 12.h),
                    _buildLongitudeField(isDark),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildLatitudeField(isDark)),
                    SizedBox(width: 16.w),
                    Expanded(child: _buildLongitudeField(isDark)),
                  ],
                ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: DigifyAsset(
              assetPath: Assets.icons.checkCircleGreen.path,
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            label: Text(
              'Set Map Location',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / 15.1,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenButton,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              elevation: 0,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(17.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              border: Border.all(color: isDark ? AppColors.successBorderDark : AppColors.greenBorder, width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to get coordinates from Google Maps:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    height: 20 / 13.8,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildNumberedPoint('Open Google Maps in your browser', 1, isDark),
                SizedBox(height: 4.h),
                _buildNumberedPoint('Navigate to the department location', 2, isDark),
                SizedBox(height: 4.h),
                _buildNumberedPoint('Right-click on the exact location', 3, isDark),
                SizedBox(height: 4.h),
                _buildNumberedPoint('Click on the coordinates to copy them', 4, isDark),
                SizedBox(height: 4.h),
                _buildNumberedPoint('Paste them into the fields above', 5, isDark),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Container(
            padding: EdgeInsets.only(top: 25.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: isDark ? AppColors.successBorderDark : const Color(0xFF7BF1A8), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.searchGreen.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.successTextDark : AppColors.greenText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Or Search for a Location',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.successTextDark : AppColors.greenText,
                        height: 24 / 15.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Search for any location by name, address, or landmark (e.g., "Kuwait Towers", "Salmiya, Kuwait", "Avenues Mall")',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.successTextDark : AppColors.greenTextSecondary,
                    height: 20 / 13.7,
                  ),
                ),
                SizedBox(height: 12.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 560.w) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DigifyTextField(
                            controller: _searchController,
                            hintText: 'e.g., Kuwait Towers, Salmiya Commercial Center',
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton.icon(
                            onPressed: null,
                            icon: DigifyAsset(
                              assetPath: Assets.icons.searchWhite.path,
                              width: 16,
                              height: 16,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            label: Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.4.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 24 / 15.4,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: DigifyTextField(
                            controller: _searchController,
                            hintText: 'e.g., Kuwait Towers, Salmiya Commercial Center',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton.icon(
                          onPressed: null,
                          icon: DigifyAsset(
                            assetPath: Assets.icons.searchWhite.path,
                            width: 16,
                            height: 16,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          label: Text(
                            'Search',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.4.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 24 / 15.4,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatitudeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latitude',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 13.8,
          ),
        ),
        SizedBox(height: 8.h),
        DigifyTextField(controller: _latitudeController, hintText: 'e.g., 29.3759', keyboardType: TextInputType.number),
        SizedBox(height: 4.h),
        Text(
          'Valid range: -90 to 90',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 16 / 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLongitudeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Longitude',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 13.7,
          ),
        ),
        SizedBox(height: 8.h),
        DigifyTextField(
          controller: _longitudeController,
          hintText: 'e.g., 47.9774',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 4.h),
        Text(
          'Valid range: -180 to 180',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 16 / 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSendEmailContent(bool isDark, bool isMobile) {
    final horizontalPadding = isMobile ? 18.w : 25.w;
    final bottomPadding = isMobile ? 32.h : 37.h;
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 25.h, horizontalPadding, bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.purpleBgDark.withValues(alpha: 0.2) : AppColors.purpleBg,
        border: Border.all(color: isDark ? AppColors.purpleBorderDark : AppColors.purpleBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.emailEnvelopePurple.path,
                width: 20,
                height: 20,
                color: isDark ? AppColors.purpleTextDark : AppColors.purpleText,
              ),
              SizedBox(width: 8.w),
              Text(
                'Send Location Request via Email',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.purpleTextDark : AppColors.purpleText,
                  height: 24 / 15.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Send an email to someone at the department location. They will receive a link to mark the current location using their device\'s GPS.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.purpleTextDark : AppColors.purpleTextSecondary,
              height: 20 / 13.6,
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recipient Email Address',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.8,
                ),
              ),
              SizedBox(height: 8.h),
              DigifyTextField(
                controller: _emailController,
                hintText: 'manager@company.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: DigifyAsset(assetPath: Assets.icons.sendEmailPurple.path, width: 20, height: 20, color: Colors.white),
            label: Text(
              'Send Location Request Email',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 24 / 15.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statIconPurple,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              elevation: 0,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: DigifyAsset(
                  assetPath: Assets.icons.copyGray.path,
                  width: 16,
                  height: 16,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                ),
                label: Text(
                  'Copy Location Link',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                    height: 24 / 15.3,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Or copy the link to share manually',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                  height: 16 / 11.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Container(
            padding: EdgeInsets.only(top: 25.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: isDark ? AppColors.purpleBorderDark : const Color(0xFFDAB2FF), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.searchPurple.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.purpleTextDark : AppColors.purpleText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Or Search & Set Location Yourself',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.purpleTextDark : AppColors.purpleText,
                        height: 24 / 15.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'If you prefer to set the location now, search for the department location below',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.purpleTextDark : AppColors.purpleTextSecondary,
                    height: 20 / 13.6,
                  ),
                ),
                SizedBox(height: 12.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 560.w) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DigifyTextField(
                            controller: _searchController,
                            hintText: 'e.g., Kuwait Towers, Salmiya Commercial Center',
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton.icon(
                            onPressed: null,
                            icon: DigifyAsset(
                              assetPath: Assets.icons.searchWhite.path,
                              width: 16,
                              height: 16,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            label: Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.4.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 24 / 15.4,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: DigifyTextField(
                            controller: _searchController,
                            hintText: 'e.g., Kuwait Towers, Salmiya Commercial Center',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton.icon(
                          onPressed: null,
                          icon: DigifyAsset(
                            assetPath: Assets.icons.searchWhite.path,
                            width: 16,
                            height: 16,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          label: Text(
                            'Search',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.4.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 24 / 15.4,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSection(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Radius (meters)',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 13.8,
          ),
        ),
        SizedBox(height: 8.h),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigifyTextField(controller: _radiusController, keyboardType: TextInputType.number),
                  SizedBox(height: 8.h),
                  Text(
                    'meters',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                      height: 24 / 15.3,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: DigifyTextField(controller: _radiusController, keyboardType: TextInputType.number),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'meters',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                      height: 24 / 15.3,
                    ),
                  ),
                ],
              ),
        SizedBox(height: 8.h),
        Text(
          'Employees can mark attendance when they\'re within this radius of the department location (10-10,000 meters)',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 20 / 13.6,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 16.w,
          children: [
            Text(
              '100m ≈ Small building',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                height: 20 / 13.7,
              ),
            ),
            Text(
              '500m ≈ Large campus',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                height: 20 / 13.7,
              ),
            ),
            Text(
              '1000m ≈ 1 kilometer',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                height: 20 / 13.7,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceInfo(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14.r : 17.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.infoCircleAttendance.path,
                width: 18,
                height: 18,
                color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Attendance Tracking Information',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.4.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                    height: 24 / 15.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildBulletPoint('Employees assigned to this department will use this location for attendance', isDark),
          SizedBox(height: 4.h),
          _buildBulletPoint('Attendance can only be marked when within the specified radius', isDark),
          SizedBox(height: 4.h),
          _buildBulletPoint('GPS coordinates are used to verify employee location during clock-in/out', isDark),
          SizedBox(height: 4.h),
          _buildBulletPoint('Location data is encrypted and stored securely', isDark),
          SizedBox(height: 4.h),
          _buildBulletPoint('You can update the location and radius at any time', isDark),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark, {String? boldPart}) {
    if (boldPart != null) {
      final parts = text.split(boldPart);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
              height: 20 / 14,
            ),
          ),
          SizedBox(width: 13.5.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                  height: 20 / 13.6,
                ),
                children: [
                  if (parts.isNotEmpty) TextSpan(text: parts[0]),
                  TextSpan(
                    text: boldPart,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (parts.length > 1) TextSpan(text: parts[1]),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
            height: 20 / 14,
          ),
        ),
        SizedBox(width: 13.5.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
              height: 20 / 13.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberedPoint(String text, int number, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
            height: 20 / 14,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 20 / 13.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark, bool isMobile) {
    final cancelButton = Material(
      color: isDark ? AppColors.cardBackgroundDark : Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 9.h),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.borderGreyDark : const Color(0xFFD1D5DC), width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 24 / 15.3,
            ),
          ),
        ),
      ),
    );

    final resetButton = Material(
      color: isDark ? AppColors.cardBackgroundDark : Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 9.h),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.borderGreyDark : const Color(0xFFD1D5DC), width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.resetIcon.path,
                width: 18,
                height: 18,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              ),
              SizedBox(width: 8.w),
              Text(
                'Reset',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 24 / 15.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final saveButton = Opacity(
      opacity: 0.5,
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: null,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DigifyAsset(assetPath: Assets.icons.saveLocationIcon.path, width: 18, height: 18, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Save Geo-Location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 24 / 15.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cancelButton,
                SizedBox(height: 12.h),
                resetButton,
                SizedBox(height: 12.h),
                saveButton,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cancelButton,
                Row(
                  children: [
                    resetButton,
                    SizedBox(width: 12.w),
                    saveButton,
                  ],
                ),
              ],
            ),
    );
  }
}
