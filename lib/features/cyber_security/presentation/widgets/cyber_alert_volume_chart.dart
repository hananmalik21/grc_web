import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';

class CyberAlertVolumeChart extends StatelessWidget {
  const CyberAlertVolumeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'ALERT VOLUME — JUNE 2026',
                style: TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const Wrap(
                spacing: 10,
                runSpacing: 4,
                children: [
                  _LegendItem(color: AppColors.cyberCritical, label: 'Critical'),
                  _LegendItem(color: AppColors.cyberHigh, label: 'High'),
                  _LegendItem(color: AppColors.cyberMedium, label: 'Medium'),
                  _LegendItem(color: AppColors.cyberLow, label: 'Low'),
                ],
              ),
            ],
          ),
          const Gap(20),
          SizedBox(
            height: 220.h,
            width: double.infinity,
            child: const CustomPaint(
              painter: _AlertVolumeCanvasPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertVolumeCanvasPainter extends CustomPainter {
  const _AlertVolumeCanvasPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 32.0;
    const bottomMargin = 24.0;
    const topMargin = 8.0;
    const rightMargin = 8.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    const maxY = 125.0;

    final gridPaint = Paint()
      ..color = AppColors.cyberCardBorder
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: AppColors.textPlaceholderDark,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
    );

    for (final yVal in CyberDashboardMockData.alertVolumeYLabels) {
      final normY = yVal / maxY;
      final yPos = topMargin + chartHeight * (1.0 - normY);

      canvas.drawLine(
        Offset(leftMargin, yPos),
        Offset(leftMargin + chartWidth, yPos),
        gridPaint,
      );

      final textSpan = TextSpan(text: '$yVal', style: textStyle);
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(leftMargin - tp.width - 8, yPos - tp.height / 2));
    }

    final numPoints = CyberDashboardMockData.alertVolumeXLabels.length;
    for (int i = 0; i < numPoints; i++) {
      final xPos = leftMargin + (chartWidth / (numPoints - 1)) * i;

      final textSpan = TextSpan(text: CyberDashboardMockData.alertVolumeXLabels[i], style: textStyle);
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(xPos - tp.width / 2, size.height - bottomMargin + 6));
    }

    for (int s = 0; s < CyberDashboardMockData.alertVolumeSeriesData.length; s++) {
      final data = CyberDashboardMockData.alertVolumeSeriesData[s];
      final color = CyberDashboardMockData.alertVolumeSeriesColors[s];

      final points = <Offset>[];
      for (int i = 0; i < data.length; i++) {
        final x = leftMargin + (chartWidth / (data.length - 1)) * i;
        final y = topMargin + chartHeight * (1.0 - (data[i] / maxY));
        points.add(Offset(x, y));
      }

      if (points.isEmpty) continue;

      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
        final controlX2 = controlX1;
        linePath.cubicTo(controlX1, p0.dy, controlX2, p1.dy, p1.dx, p1.dy);
      }

      final fillPath = Path.from(linePath)
        ..lineTo(points.last.dx, topMargin + chartHeight)
        ..lineTo(points.first.dx, topMargin + chartHeight)
        ..close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromLTWH(leftMargin, topMargin, chartWidth, chartHeight),
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);

      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      canvas.drawPath(linePath, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AlertVolumeCanvasPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        const Gap(5),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
