import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';

import 'dart:math' as math;

class CyberFindingSeverityDonut extends StatefulWidget {
  final List<double>? values;
  final List<Color>? colors;

  const CyberFindingSeverityDonut({super.key, this.values, this.colors});

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  State<CyberFindingSeverityDonut> createState() =>
      _CyberFindingSeverityDonutState();
}

class _CyberFindingSeverityDonutState extends State<CyberFindingSeverityDonut> {
  final ValueNotifier<int?> _hoveredIndexNotifier = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _hoveredIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final values =
        widget.values ?? CyberDashboardMockData.findingSeverityValues;
    final colors =
        widget.colors ??
        const [
          AppColors.cyberCritical,
          AppColors.cyberHigh,
          AppColors.cyberMedium,
          CyberFindingSeverityDonut.skyBlue,
        ];
    final labels = ['Critical', 'High', 'Medium', 'Low'];
    final total = values.fold<double>(0, (sum, val) => sum + val).toInt();
    final isMobile = MediaQuery.of(context).size.width < 600;
    final donutSize = isMobile ? 110.r : 140.r;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12.r : 18.r),
      decoration: BoxDecoration(
        color: Colors.white, // Solid white card
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FINDING SEVERITY',
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: isMobile ? 13.sp : 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(isMobile ? 8.h : 14.h),
          Expanded(
            child: Center(
              child: SizedBox(
                width: donutSize,
                height: donutSize,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onHover: (event) {
                    final pos = event.localPosition;
                    final center = Offset(donutSize / 2, donutSize / 2);
                    final dx = pos.dx - center.dx;
                    final dy = pos.dy - center.dy;
                    final dist = math.sqrt(dx * dx + dy * dy);

                    final outerR = donutSize / 2;
                    final innerR = (donutSize / 2) - 16.0;

                    if (dist >= innerR - 5 && dist <= outerR + 5) {
                      double angle = math.atan2(dy, dx) + (math.pi / 2);
                      if (angle < 0) {
                        angle += 2 * math.pi;
                      }

                      final totalVal = values.fold<double>(
                        0,
                        (sum, v) => sum + v,
                      );
                      int? foundIndex;

                      if (totalVal > 0) {
                        double currentAngle = 0;
                        for (int i = 0; i < values.length; i++) {
                          final sweep = (values[i] / totalVal) * 2 * math.pi;
                          if (angle >= currentAngle &&
                              angle <= currentAngle + sweep) {
                            foundIndex = i;
                            break;
                          }
                          currentAngle += sweep;
                        }
                      }

                      if (foundIndex != _hoveredIndexNotifier.value) {
                        _hoveredIndexNotifier.value = foundIndex;
                      }
                    } else {
                      if (_hoveredIndexNotifier.value != null) {
                        _hoveredIndexNotifier.value = null;
                      }
                    }
                  },
                  onExit: (_) {
                    if (_hoveredIndexNotifier.value != null) {
                      _hoveredIndexNotifier.value = null;
                    }
                  },
                  child: ValueListenableBuilder<int?>(
                    valueListenable: _hoveredIndexNotifier,
                    builder: (context, hoveredIndex, _) {
                      final isValidIndex =
                          hoveredIndex != null &&
                          hoveredIndex >= 0 &&
                          hoveredIndex < labels.length &&
                          hoveredIndex < values.length &&
                          hoveredIndex < colors.length;
                      final hoveredLabel = isValidIndex
                          ? labels[hoveredIndex]
                          : 'TOTAL';
                      final hoveredValue = isValidIndex
                          ? values[hoveredIndex].toInt().toString()
                          : '$total';
                      final hoveredColor = isValidIndex
                          ? colors[hoveredIndex]
                          : const Color(0xFF0F172A);

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(donutSize, donutSize),
                            painter: _DonutChartPainter(
                              values: values,
                              colors: colors,
                              strokeWidth: isMobile ? 14.0 : 16.0,
                              hoveredIndex: hoveredIndex,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 150),
                                style: TextStyle(
                                  color: hoveredColor,
                                  fontSize: isMobile ? 18.sp : 22.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                                child: Text(hoveredValue),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 150),
                                style: TextStyle(
                                  color: hoveredIndex != null
                                      ? hoveredColor
                                      : const Color(0xFF64748B),
                                  fontSize: isMobile ? 8.sp : 8.5.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                child: Text(hoveredLabel.toUpperCase()),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Gap(isMobile ? 10.h : 16.h),
          ValueListenableBuilder<int?>(
            valueListenable: _hoveredIndexNotifier,
            builder: (context, hoveredIndex, _) {
              return Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  _SeverityLegendItem(
                    label: 'Critical',
                    count: values.isNotEmpty
                        ? values[0].toInt().toString()
                        : '0',
                    color: colors[0],
                    isSelected: hoveredIndex == 0,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 0 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'High',
                    count: values.length > 1
                        ? values[1].toInt().toString()
                        : '0',
                    color: colors[1],
                    isSelected: hoveredIndex == 1,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 1 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'Medium',
                    count: values.length > 2
                        ? values[2].toInt().toString()
                        : '0',
                    color: colors[2],
                    isSelected: hoveredIndex == 2,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 2 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'Low',
                    count: values.length > 3
                        ? values[3].toInt().toString()
                        : '0',
                    color: colors[3],
                    isSelected: hoveredIndex == 3,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 3 : null;
                    },
                  ),
                ],
              );
            },
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
  final int? hoveredIndex;

  const _DonutChartPainter({
    required this.values,
    required this.colors,
    required this.strokeWidth,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final total = values.fold<double>(0, (sum, val) => sum + val);

    if (total == 0) {
      final trackPaint = Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, trackPaint);
      return;
    }

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final isHovered = hoveredIndex == i;
      final currentStroke = isHovered ? strokeWidth + 4 : strokeWidth;

      final paint = Paint()
        ..color = isHovered
            ? colors[i]
            : (hoveredIndex != null
                  ? colors[i].withValues(alpha: 0.35)
                  : colors[i])
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentStroke
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
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.hoveredIndex != hoveredIndex;
}

class _SeverityLegendItem extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final bool isSelected;
  final ValueChanged<bool> onHover;

  const _SeverityLegendItem({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isSelected ? 1.0 : 0.85,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF475569),
                      fontSize: 10.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Gap(2),
              Text(
                count,
                style: TextStyle(
                  color: isSelected ? color : const Color(0xFF0F172A),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
