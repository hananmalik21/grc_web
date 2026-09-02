import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

class CyberAlertVolumeChart extends StatefulWidget {
  final List<List<double>>? seriesData;
  final List<String>? xLabels;
  final List<double>? yLabels;

  const CyberAlertVolumeChart({
    super.key,
    this.seriesData,
    this.xLabels,
    this.yLabels,
  });

  @override
  State<CyberAlertVolumeChart> createState() => _CyberAlertVolumeChartState();
}

class _CyberAlertVolumeChartState extends State<CyberAlertVolumeChart> {
  final ValueNotifier<Offset?> _hoverPositionNotifier = ValueNotifier<Offset?>(null);

  @override
  void dispose() {
    _hoverPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = _getMonthName(now.month);
    final year = now.year;

    final xLabels = widget.xLabels ?? _generateDateLabels(now);
    final seriesData = widget.seriesData ??
        [
          List.filled(xLabels.length, 0.0), // Low
          List.filled(xLabels.length, 0.0), // Medium
          List.filled(xLabels.length, 0.0), // High
          List.filled(xLabels.length, 0.0), // Critical
        ];

    final hasAnyActivity = seriesData.any((series) => series.any((v) => v > 0));

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
                'ALERT VOLUME — $monthName $year',
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
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: !hasAnyActivity
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.show_chart_rounded,
                            size: 36.r,
                            color: AppColors.dashCyberSecurity.withValues(alpha: 0.4),
                          ),
                          Gap(8.h),
                          Text(
                            'No Security Alerts Ingested',
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap(2.h),
                          Text(
                            'Connect cloud telemetry to visualize alert ingestion frequency',
                            style: TextStyle(
                              color: AppColors.textPlaceholderDark,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      onHover: (event) {
                        _hoverPositionNotifier.value = event.localPosition;
                      },
                      onExit: (_) {
                        _hoverPositionNotifier.value = null;
                      },
                      child: ValueListenableBuilder<Offset?>(
                        valueListenable: _hoverPositionNotifier,
                        builder: (context, hoverPos, _) {
                          return CustomPaint(
                            painter: _AlertVolumeCanvasPainter(
                              seriesData: seriesData,
                              xLabels: xLabels,
                              hoverPosition: hoverPos,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];
    return (month >= 1 && month <= 12) ? months[month - 1] : 'CURRENT';
  }

  static List<String> _generateDateLabels(DateTime now) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final labels = <String>[];
    for (int i = 1; i <= daysInMonth; i += 3) {
      labels.add('$i/${now.month}');
    }
    return labels;
  }
}

class _AlertVolumeCanvasPainter extends CustomPainter {
  final List<List<double>> seriesData;
  final List<String> xLabels;
  final Offset? hoverPosition;

  const _AlertVolumeCanvasPainter({
    required this.seriesData,
    required this.xLabels,
    this.hoverPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 32.0;
    const bottomMargin = 24.0;
    const topMargin = 8.0;
    const rightMargin = 8.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;

    double maxY = 10.0;
    for (final s in seriesData) {
      for (final v in s) {
        if (v > maxY) maxY = v;
      }
    }

    if (chartWidth <= 0 || chartHeight <= 0) return;

    final gridPaint = Paint()
      ..color = AppColors.cyberCardBorder
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: AppColors.textPlaceholderDark,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
    );

    final ySteps = [0.0, maxY * 0.25, maxY * 0.5, maxY * 0.75, maxY];
    for (final yVal in ySteps) {
      final normY = yVal / maxY;
      final yPos = topMargin + chartHeight * (1.0 - normY);

      canvas.drawLine(
        Offset(leftMargin, yPos),
        Offset(leftMargin + chartWidth, yPos),
        gridPaint,
      );

      final textSpan = TextSpan(text: '${yVal.toInt()}', style: textStyle);
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(leftMargin - tp.width - 8, yPos - tp.height / 2));
    }

    final numPoints = xLabels.length;
    if (numPoints > 1) {
      for (int i = 0; i < numPoints; i++) {
        final xPos = leftMargin + (chartWidth / (numPoints - 1)) * i;

        final textSpan = TextSpan(text: xLabels[i], style: textStyle);
        final tp = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(canvas, Offset(xPos - tp.width / 2, size.height - bottomMargin + 6));
      }
    }

    final seriesColors = [
      AppColors.cyberLow,
      AppColors.cyberMedium,
      AppColors.cyberHigh,
      AppColors.cyberCritical,
    ];

    // Series curves
    for (int s = 0; s < seriesData.length; s++) {
      final data = seriesData[s];
      final color = s < seriesColors.length ? seriesColors[s] : AppColors.dashCyberSecurity;

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
  bool shouldRepaint(covariant _AlertVolumeCanvasPainter oldDelegate) =>
      oldDelegate.hoverPosition != hoverPosition || oldDelegate.seriesData != seriesData;
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
