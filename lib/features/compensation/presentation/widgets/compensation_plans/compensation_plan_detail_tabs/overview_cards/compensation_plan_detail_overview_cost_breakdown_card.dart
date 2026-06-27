import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/overview_shell_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CostSlice {
  final String label;
  final double percentage;
  final Color color;

  const CostSlice({required this.label, required this.percentage, required this.color});
}

class CompensationPlanDetailOverviewCostBreakdownCard extends StatefulWidget {
  final List<CostSlice> sections;

  const CompensationPlanDetailOverviewCostBreakdownCard({super.key, required this.sections});

  @override
  State<CompensationPlanDetailOverviewCostBreakdownCard> createState() =>
      _CompensationPlanDetailOverviewCostBreakdownCardState();
}

class _CompensationPlanDetailOverviewCostBreakdownCardState
    extends State<CompensationPlanDetailOverviewCostBreakdownCard> {
  int touchedIndex = -1;
  Offset? tooltipPosition;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return OverviewShellCard(
      title: 'Cost Breakdown',
      subtitle: 'Monthly compensation cost distribution',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 380.w;

          final pieChart = AspectRatio(
            aspectRatio: 1,
            child: MouseRegion(
              onExit: (_) => setState(() {
                touchedIndex = -1;
                tooltipPosition = null;
              }),
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      startDegreeOffset: 0,
                      borderData: FlBorderData(show: false),
                      sections: [
                        for (var index = 0; index < widget.sections.length; index++)
                          _buildSection(item: widget.sections[index], isDark: isDark, isTouched: index == touchedIndex),
                      ],
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, pieTouchResponse) {
                          final nextIndex = event.isInterestedForInteractions
                              ? pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1
                              : -1;

                          setState(() {
                            touchedIndex = nextIndex;
                            if (nextIndex >= 0) {
                              tooltipPosition = event.localPosition;
                            } else {
                              tooltipPosition = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  if (touchedIndex >= 0 && tooltipPosition != null)
                    Positioned(
                      left: (tooltipPosition?.dx ?? 0) - 48.w,
                      top: (tooltipPosition?.dy ?? 0) - 54.h,
                      child: _PieTooltip(item: widget.sections[touchedIndex], isDark: isDark),
                    ),
                ],
              ),
            ),
          );

          final legend = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in widget.sections)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        '${item.percentage.toStringAsFixed(1)}%',
                        style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          );

          if (isCompact) {
            return Column(
              children: [
                SizedBox(height: 220.h, child: pieChart),
                Gap(12.h),
                legend,
              ],
            );
          }

          return SizedBox(
            height: 220.h,
            child: Row(
              children: [
                Expanded(flex: 3, child: pieChart),
                Gap(16.w),
                Expanded(flex: 2, child: legend),
              ],
            ),
          );
        },
      ),
    );
  }

  PieChartSectionData _buildSection({required CostSlice item, required bool isDark, required bool isTouched}) {
    return PieChartSectionData(
      color: item.color,
      value: item.percentage,
      title: '',
      radius: isTouched ? 98.w : 92.w,
      borderSide: BorderSide(color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground, width: 1.2),
    );
  }
}

class _PieTooltip extends StatelessWidget {
  final CostSlice item;
  final bool isDark;

  const _PieTooltip({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.textPrimary : AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: item.color, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
              ),
              Gap(8.w),
              Text(
                item.label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            'Share: ${item.percentage.toStringAsFixed(1)}%',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondaryDark, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
