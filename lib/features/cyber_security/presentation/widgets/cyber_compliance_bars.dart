import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/data/models/compliance_dto.dart';

class CyberComplianceBars extends StatefulWidget {
  const CyberComplianceBars({super.key, required this.frameworks});

  final List<FrameworkComplianceItem> frameworks;

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  State<CyberComplianceBars> createState() => _CyberComplianceBarsState();
}

class _CyberComplianceBarsState extends State<CyberComplianceBars> {
  final ValueNotifier<int?> _hoveredIndexNotifier = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _hoveredIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int?>(
            valueListenable: _hoveredIndexNotifier,
            builder: (context, hoveredIndex, _) {
              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    'FRAMEWORK COMPLIANCE',
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: isMobile ? 13.sp : 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (hoveredIndex != null)
                    Text(
                      '${widget.frameworks[hoveredIndex].name}: ${widget.frameworks[hoveredIndex].score.toInt()}%',
                      style: TextStyle(
                        color: _colorFor(widget.frameworks[hoveredIndex].code),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              );
            },
          ),
          Gap(isMobile ? 8.h : 12.h),
          if (widget.frameworks.isEmpty)
            Text(
              'No framework assessments available',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 12.sp,
              ),
            )
          else
            for (int i = 0; i < widget.frameworks.length; i++) ...[
              _buildFrameworkRow(
                index: i,
                label: widget.frameworks[i].name,
                percentage: (widget.frameworks[i].score / 100)
                    .clamp(0, 1)
                    .toDouble(),
                barColor: _colorFor(widget.frameworks[i].code),
                tooltip: widget.frameworks[i].name,
                isMobile: isMobile,
              ),
              if (i < widget.frameworks.length - 1) Gap(isMobile ? 6.h : 8.h),
            ],
          Gap(isMobile ? 8.h : 10.h),
          Row(
            children: [
              SizedBox(width: isMobile ? 54.w : 64.w),
              const Gap(8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAxisLabel('0%'),
                    _buildAxisLabel('25%'),
                    _buildAxisLabel('50%'),
                    _buildAxisLabel('75%'),
                    _buildAxisLabel('100%'),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 32.w : 42.w),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorFor(String code) {
    final normalized = code.toUpperCase();
    if (normalized.contains('NIST')) return CyberComplianceBars.skyBlue;
    if (normalized.contains('CIS')) return AppColors.primary;
    if (normalized.contains('ISO')) return AppColors.purple;
    if (normalized.contains('SOC')) return AppColors.successText;
    return AppColors.warningText;
  }

  Widget _buildAxisLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFrameworkRow({
    required int index,
    required String label,
    required double percentage,
    required Color barColor,
    required String tooltip,
    required bool isMobile,
  }) {
    final pctInt = (percentage * 100).toInt();

    return Tooltip(
      message: '$label: $pctInt% compliance\n$tooltip',
      waitDuration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6.r),
      ),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
      ),
      child: MouseRegion(
        onEnter: (_) => _hoveredIndexNotifier.value = index,
        onExit: (_) {
          if (_hoveredIndexNotifier.value == index) {
            _hoveredIndexNotifier.value = null;
          }
        },
        cursor: SystemMouseCursors.click,
        child: ValueListenableBuilder<int?>(
          valueListenable: _hoveredIndexNotifier,
          builder: (context, hoveredIndex, _) {
            final isHovered = hoveredIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isHovered
                    ? barColor.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: isMobile ? 54.w : 64.w,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isHovered
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF334155),
                        fontSize: isMobile ? 10.sp : 11.sp,
                        fontWeight: isHovered
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: Container(
                        height: 12.h,
                        color: const Color(0xFFF1F5F9),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? barColor.withValues(alpha: 0.95)
                                  : barColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: isMobile ? 28.w : 34.w,
                    child: Text(
                      '$pctInt%',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: isHovered ? barColor : const Color(0xFF0F172A),
                        fontSize: isMobile ? 10.sp : 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
