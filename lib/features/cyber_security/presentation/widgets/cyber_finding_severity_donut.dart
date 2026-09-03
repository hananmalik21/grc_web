import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberFindingSeverityDonut extends StatelessWidget {
  const CyberFindingSeverityDonut({super.key});

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
          Text(
            'FINDING SEVERITY',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(16),
          // Custom Canvas Donut Chart with Center Text
          Center(
            child: SizedBox(
              width: 140.r,
              height: 140.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(140.r, 140.r),
                    painter: const _DonutChartPainter(
                      values: [4, 14, 84, 210],
                      colors: [
                        Color(0xFFEF4444), // Critical
                        Color(0xFFF97316), // High
                        Color(0xFFFBBF24), // Medium
                        Color(0xFF38BDF8), // Low
                      ],
                      strokeWidth: 16.0,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '312',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Gap(20),
          // Legend
          Column(
            children: const [
              _SeverityLegendRow(
                color: Color(0xFFEF4444),
                label: 'Critical',
                count: '4',
              ),
              Gap(8),
              _SeverityLegendRow(
                color: Color(0xFFF97316),
                label: 'High',
                count: '14',
              ),
              Gap(8),
              _SeverityLegendRow(
                color: Color(0xFFFBBF24),
                label: 'Medium',
                count: '84',
              ),
              Gap(8),
              _SeverityLegendRow(
                color: Color(0xFF38BDF8),
                label: 'Low',
                count: '210',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  const _DonutChartPainter({
    required this.values,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0.0, (sum, val) => sum + val);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;
    const gapAngle = 0.04; // subtle clean separation gap in radians

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * (2 * math.pi) - gapAngle;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      if (sweepAngle > 0) {
        canvas.drawArc(rect, startAngle + (gapAngle / 2), sweepAngle, false, paint);
      }
      startAngle += (values[i] / total) * (2 * math.pi);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => false;
}

class _SeverityLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String count;

  const _SeverityLegendRow({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
