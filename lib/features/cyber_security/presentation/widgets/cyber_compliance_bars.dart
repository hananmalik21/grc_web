import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

class CyberComplianceBars extends StatefulWidget {
  const CyberComplianceBars({super.key});

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
    final frameworks = [
      {'label': 'NIST CSF', 'pct': 0.72, 'color': AppColors.dashCyberSecurity, 'desc': 'National Institute of Standards and Technology Framework'},
      {'label': 'CIS v8', 'pct': 0.80, 'color': AppColors.primaryLight, 'desc': 'Center for Internet Security Controls v8'},
      {'label': 'ISO 27001', 'pct': 0.68, 'color': AppColors.barPurple, 'desc': 'Information Security Management Standard'},
      {'label': 'SOC 2', 'pct': 0.85, 'color': AppColors.cyberLiveGreen, 'desc': 'Trust Services Criteria (Security, Availability)'},
      {'label': 'CSA CCM', 'pct': 0.62, 'color': AppColors.cyberMedium, 'desc': 'Cloud Security Alliance Cloud Controls Matrix'},
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int?>(
            valueListenable: _hoveredIndexNotifier,
            builder: (context, hoveredIndex, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FRAMEWORK COMPLIANCE',
                    style: TextStyle(
                      color: AppColors.textTertiaryDark,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (hoveredIndex != null)
                    Text(
                      '${frameworks[hoveredIndex]['label']}: ${((frameworks[hoveredIndex]['pct'] as double) * 100).toInt()}% Compliant',
                      style: TextStyle(
                        color: frameworks[hoveredIndex]['color'] as Color,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              );
            },
          ),
          const Gap(10),
          for (int i = 0; i < frameworks.length; i++) ...[
            _buildFrameworkRow(
              index: i,
              label: frameworks[i]['label'] as String,
              percentage: frameworks[i]['pct'] as double,
              barColor: frameworks[i]['color'] as Color,
              tooltip: frameworks[i]['desc'] as String,
            ),
            if (i < frameworks.length - 1) const Gap(6),
          ],
          const Gap(8),
          Row(
            children: [
              SizedBox(width: 58.w),
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
              SizedBox(width: 38.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAxisLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPlaceholderDark,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildFrameworkRow({
    required int index,
    required String label,
    required double percentage,
    required Color barColor,
    required String tooltip,
  }) {
    final pctInt = (percentage * 100).toInt();

    return Tooltip(
      message: '$label: $pctInt% compliance\n$tooltip',
      waitDuration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.cyberDarkBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      textStyle: TextStyle(
        color: AppColors.textPrimaryDark,
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
                color: isHovered ? barColor.withValues(alpha: 0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 58.w,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isHovered ? AppColors.textPrimaryDark : AppColors.textTertiaryDark,
                        fontSize: 10.sp,
                        fontWeight: isHovered ? FontWeight.w700 : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: Container(
                        height: 12.h,
                        color: AppColors.cardBackgroundGreyDark,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isHovered ? barColor.withValues(alpha: 0.95) : barColor,
                              borderRadius: BorderRadius.circular(3.r),
                              boxShadow: isHovered
                                  ? [
                                      BoxShadow(
                                        color: barColor.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 30.w,
                    child: Text(
                      '$pctInt%',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: isHovered ? barColor : AppColors.textPrimaryDark,
                        fontSize: 10.5.sp,
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
