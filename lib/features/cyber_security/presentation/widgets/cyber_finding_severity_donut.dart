import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';

class CyberFindingSeverityDonut extends StatelessWidget {
  const CyberFindingSeverityDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FINDING SEVERITY',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(14),
          Center(
            child: SizedBox(
              width: 130.r,
              height: 130.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(130.r, 130.r),
                    painter: const _DonutChartPainter(
                      values: CyberDashboardMockData.findingSeverityValues,
                      colors: CyberDashboardMockData.findingSeverityColors,
                      strokeWidth: 15.0,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '312',
                        style: TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'TOTAL',
                        style: TextStyle(
                          color: AppColors.textPlaceholderDark,
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 8.w,
            runSpacing: 8.h,
            children: const [
              _SeverityLegendItem(
                label: 'Critical',
                count: '4',
                color: AppColors.cyberCritical,
              ),
              _SeverityLegendItem(
                label: 'High',
                count: '14',
                color: AppColors.cyberHigh,
              ),
              _SeverityLegendItem(
                label: 'Medium',
                count: '84',
                color: AppColors.cyberMedium,
              ),
              _SeverityLegendItem(
                label: 'Low',
                count: '210',
                color: AppColors.cyberLow,
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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final total = values.fold<double>(0, (sum, val) => sum + val);

    if (total == 0) return;

    double startAngle = -3.141592653589793 / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * 3.141592653589793;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => false;
}

class _SeverityLegendItem extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SeverityLegendItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7.r,
              height: 7.r,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textTertiaryDark,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Gap(2),
        Text(
          count,
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
