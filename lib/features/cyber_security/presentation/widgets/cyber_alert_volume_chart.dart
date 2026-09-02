import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberAlertVolumeChart extends StatelessWidget {
  const CyberAlertVolumeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF070C18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF131E30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Legend
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'ALERT VOLUME — JUNE 2026',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 4,
                children: const [
                  _LegendItem(color: Color(0xFFEF4444), label: 'Critical'),
                  _LegendItem(color: Color(0xFFF97316), label: 'High'),
                  _LegendItem(color: Color(0xFFFBBF24), label: 'Medium'),
                  _LegendItem(color: Color(0xFF38BDF8), label: 'Low'),
                ],
              ),
            ],
          ),
          const Gap(20),
          // Native Smooth Canvas Line Chart
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

  static const List<String> xLabels = ['6/1', '6/6', '6/11', '6/16', '6/21', '6/26'];
  static const List<int> yLabels = [0, 30, 60, 90, 120];

  static const List<List<double>> seriesData = [
    // Low
    [42, 38, 68, 52, 106, 50],
    // Medium
    [24, 28, 40, 35, 68, 30],
    // High
    [14, 16, 22, 19, 38, 18],
    // Critical
    [4, 5, 8, 6, 16, 6],
  ];

  static const List<Color> seriesColors = [
    Color(0xFF38BDF8),
    Color(0xFFFBBF24),
    Color(0xFFF97316),
    Color(0xFFEF4444),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 32.0;
    const bottomMargin = 24.0;
    const topMargin = 8.0;
    const rightMargin = 8.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    const maxY = 125.0;

    // 1. Draw Grid Lines & Y-Axis Labels
    final gridPaint = Paint()
      ..color = const Color(0xFF131E30)
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: const Color(0xFF64748B),
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
    );

    for (final yVal in yLabels) {
      final normY = yVal / maxY;
      final yPos = topMargin + chartHeight * (1.0 - normY);

      // Horizontal grid line
      canvas.drawLine(
        Offset(leftMargin, yPos),
        Offset(leftMargin + chartWidth, yPos),
        gridPaint,
      );

      // Y-axis label
      final textSpan = TextSpan(text: '$yVal', style: textStyle);
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(leftMargin - tp.width - 8, yPos - tp.height / 2));
    }

    // 2. Draw X-Axis Labels
    final numPoints = xLabels.length;
    for (int i = 0; i < numPoints; i++) {
      final xPos = leftMargin + (chartWidth / (numPoints - 1)) * i;

      final textSpan = TextSpan(text: xLabels[i], style: textStyle);
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(xPos - tp.width / 2, size.height - bottomMargin + 6));
    }

    // 3. Draw Curves & Area Fills (from Low to Critical)
    for (int s = 0; s < seriesData.length; s++) {
      final data = seriesData[s];
      final color = seriesColors[s];

      final points = <Offset>[];
      for (int i = 0; i < data.length; i++) {
        final x = leftMargin + (chartWidth / (data.length - 1)) * i;
        final y = topMargin + chartHeight * (1.0 - (data[i] / maxY));
        points.add(Offset(x, y));
      }

      if (points.isEmpty) continue;

      // Build smooth cubic bezier path
      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
        final controlX2 = controlX1;
        linePath.cubicTo(controlX1, p0.dy, controlX2, p1.dy, p1.dx, p1.dy);
      }

      // Build closed area path for fill
      final fillPath = Path.from(linePath)
        ..lineTo(points.last.dx, topMargin + chartHeight)
        ..lineTo(points.first.dx, topMargin + chartHeight)
        ..close();

      // Draw subtle gradient fill
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

      // Draw stroke curve
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
            color: const Color(0xFF94A3B8),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
