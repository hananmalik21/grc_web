import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';

class BulkUploadDialog extends StatelessWidget {
  const BulkUploadDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BulkUploadDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        backgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
        child: Container(
          width: isMobile ? double.infinity : 684.w,
          constraints: BoxConstraints(maxHeight: 900.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, isDark, localizations, isMobile),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        _buildInstructions(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildStepDownload(localizations),
                        SizedBox(height: 24.h),
                        _buildStepUpload(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildTemplatePreview(localizations, isDark, isMobile),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(context, isDark, localizations, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLocalizations localizations, bool isMobile) {
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
            child: Text(
              localizations.bulkUploadTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.6.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.6,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            icon: DigifyAsset(
              assetPath: Assets.icons.closeDialogIcon.path,
              width: 24,
              height: 24,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(AppLocalizations localizations, bool isDark) {
    final instructions = [
      localizations.bulkUploadInstructionDownloadTemplate,
      localizations.bulkUploadInstructionRequiredFields,
      localizations.bulkUploadInstructionOptionalFields,
      localizations.bulkUploadInstructionParentCode,
      localizations.bulkUploadInstructionFileFormat,
      localizations.bulkUploadInstructionRowLimit,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.bulkUploadInstructionsTitle,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.5.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.infoTextDark : AppColors.infoText,
              height: 24 / 15.5,
            ),
          ),
          SizedBox(height: 8.h),
          ...instructions.map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                      height: 20 / 14,
                    ),
                  ),
                  SizedBox(width: 8.w),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDownload(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.bulkUploadStepDownloadLabel,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF364153),
            height: 20 / 13.7,
          ),
        ),
        SizedBox(height: 8.h),
        ElevatedButton.icon(
          onPressed: () {},
          icon: DigifyAsset(assetPath: Assets.icons.downloadIcon.path, width: 20, height: 20, color: Colors.white),
          label: Text(
            localizations.bulkUploadDownloadTemplate,
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildStepUpload(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.bulkUploadStepUploadLabel,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF364153),
            height: 20 / 13.7,
          ),
        ),
        SizedBox(height: 8.h),
        DashedBorder(
          borderRadius: BorderRadius.circular(10.r),
          color: const Color(0xFFD1D5DC),
          strokeWidth: 1.2,
          dashLength: 8,
          gapLength: 6,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.bulkUploadIconFigma.path,
                    width: 48,
                    height: 48,
                    color: const Color(0xFF6A7282),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    localizations.bulkUploadDropHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.1.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A5565),
                      height: 24 / 15.1,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localizations.bulkUploadSupportedFormats,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6A7282),
                      height: 20 / 13.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatePreview(AppLocalizations localizations, bool isDark, bool isMobile) {
    final columns = [
      localizations.bulkUploadTypeHeader,
      localizations.bulkUploadCodeHeader,
      localizations.bulkUploadNameHeader,
      localizations.bulkUploadNameArabicHeader,
      localizations.bulkUploadParentCodeHeader,
      localizations.bulkUploadManagerIdHeader,
      localizations.bulkUploadLocationHeader,
    ];
    final widths = [91, 81, 95, 86, 81, 93, 93];

    final sampleRows = [
      [
        localizations.bulkUploadSampleRow1Type,
        localizations.bulkUploadSampleRow1Code,
        localizations.bulkUploadSampleRow1Name,
        localizations.bulkUploadSampleRow1NameArabic,
        localizations.bulkUploadSampleRow1ParentCode,
        localizations.bulkUploadSampleRow1ManagerId,
        localizations.bulkUploadSampleRow1Location,
      ],
      [
        localizations.bulkUploadSampleRow2Type,
        localizations.bulkUploadSampleRow2Code,
        localizations.bulkUploadSampleRow2Name,
        localizations.bulkUploadSampleRow2NameArabic,
        localizations.bulkUploadSampleRow2ParentCode,
        localizations.bulkUploadSampleRow2ManagerId,
        localizations.bulkUploadSampleRow2Location,
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.bulkUploadTemplatePreview,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF364153),
            height: 20 / 13.8,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.all(1.r),
              child: Column(
                children: [
                  Container(
                    color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
                    child: Row(
                      children: List.generate(
                        columns.length,
                        (index) => Container(
                          width: widths[index].w * (isMobile ? 0.8 : 1),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 17.75.h),
                          child: Text(
                            columns[index],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.7.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4A5565),
                              height: 20 / 13.7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...sampleRows.map(
                    (row) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                        ),
                      ),
                      child: Row(
                        children: List.generate(
                          row.length,
                          (index) => Container(
                            width: widths[index].w * (isMobile ? 0.8 : 1),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.25.h),
                            child: Text(
                              row[index],
                              style: TextStyle(
                                fontFamily: index == 3 ? '.SF Arabic' : 'Inter',
                                fontSize: index == 3 || index == 5 ? 14.sp : 13.7.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF101828),
                                height: 20 / 13.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, AppLocalizations localizations, bool isMobile) {
    final cancelButton = OutlinedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: const Color(0xFFD1D5DC), width: 1),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        backgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
      ),
      child: Text(
        localizations.cancel,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF364153),
          height: 24 / 15.3,
        ),
      ),
    );

    final uploadButton = ElevatedButton.icon(
      onPressed: () {},
      icon: DigifyAsset(assetPath: Assets.icons.bulkUploadIconFigma.path, width: 20, height: 20, color: Colors.white),
      label: Text(
        localizations.bulkUploadUploadButton,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.5.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 24 / 15.5,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: double.infinity, child: cancelButton),
                SizedBox(height: 12.h),
                SizedBox(width: double.infinity, child: uploadButton),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                SizedBox(width: 12.w),
                uploadButton,
              ],
            ),
    );
  }
}

class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  const DashedBorder({
    super.key,
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = min(metric.length, distance + dashLength);
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
