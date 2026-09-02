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

  @override
  State<CyberFindingSeverityDonut> createState() => _CyberFindingSeverityDonutState();
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
    final values = widget.values ?? CyberDashboardMockData.findingSeverityValues;
    final colors = widget.colors ?? CyberDashboardMockData.findingSeverityColors;
    final labels = ['Critical', 'High', 'Medium', 'Low'];
    final total = values.fold<double>(0, (sum, val) => sum + val).toInt();

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
          Expanded(
            child: Center(
              child: SizedBox(
                width: 140.r,
                height: 140.r,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onHover: (event) {
                    final pos = event.localPosition;
                    final center = Offset(70.r, 70.r);
                    final dx = pos.dx - center.dx;
                    final dy = pos.dy - center.dy;
                    final dist = math.sqrt(dx * dx + dy * dy);

                    // Donut inner and outer ring radius check
                    final outerR = 70.r;
                    final innerR = 70.r - 18.0;

                    if (dist >= innerR - 5 && dist <= outerR + 5) {
                      double angle = math.atan2(dy, dx) + (math.pi / 2);
                      if (angle < 0) {
                        angle += 2 * math.pi;
                      }

                      final totalVal = values.fold<double>(0, (sum, v) => sum + v);
                      int? foundIndex;

                      if (totalVal > 0) {
                        double currentAngle = 0;
                        for (int i = 0; i < values.length; i++) {
                          final sweep = (values[i] / totalVal) * 2 * math.pi;
                          if (angle >= currentAngle && angle <= currentAngle + sweep) {
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
                      final isValidIndex = hoveredIndex != null && hoveredIndex >= 0 && hoveredIndex < labels.length && hoveredIndex < values.length && hoveredIndex < colors.length;
                      final hoveredLabel = isValidIndex ? labels[hoveredIndex] : 'TOTAL';
                      final hoveredValue = isValidIndex
                          ? values[hoveredIndex].toInt().toString()
                          : '$total';
                      final hoveredColor = isValidIndex
                          ? colors[hoveredIndex]
                          : AppColors.textPrimaryDark;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(140.r, 140.r),
                            painter: _DonutChartPainter(
                              values: values,
                              colors: colors,
                              strokeWidth: 16.0,
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
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                                child: Text(hoveredValue),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 150),
                                style: TextStyle(
                                  color: hoveredIndex != null
                                      ? hoveredColor
                                      : AppColors.textPlaceholderDark,
                                  fontSize: 8.5.sp,
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
          const Gap(16),
          ValueListenableBuilder<int?>(
            valueListenable: _hoveredIndexNotifier,
            builder: (context, hoveredIndex, _) {
              return Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _SeverityLegendItem(
                    label: 'Critical',
                    count: values.isNotEmpty ? values[0].toInt().toString() : '0',
                    color: AppColors.cyberCritical,
                    isSelected: hoveredIndex == 0,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 0 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'High',
                    count: values.length > 1 ? values[1].toInt().toString() : '0',
                    color: AppColors.cyberHigh,
                    isSelected: hoveredIndex == 1,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 1 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'Medium',
                    count: values.length > 2 ? values[2].toInt().toString() : '0',
                    color: AppColors.cyberMedium,
                    isSelected: hoveredIndex == 2,
                    onHover: (hovered) {
                      _hoveredIndexNotifier.value = hovered ? 2 : null;
                    },
                  ),
                  _SeverityLegendItem(
                    label: 'Low',
                    count: values.length > 3 ? values[3].toInt().toString() : '0',
                    color: AppColors.cyberLow,
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
        ..color = AppColors.cyberCardBorder.withValues(alpha: 0.6)
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
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
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
                      color: isSelected ? AppColors.textPrimaryDark : AppColors.textTertiaryDark,
                      fontSize: 9.5.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Gap(2),
              Text(
                count,
                style: TextStyle(
                  color: isSelected ? color : AppColors.textPrimaryDark,
                  fontSize: 11.sp,
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
