import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentsCategoryPieChart extends StatefulWidget {
  const ComponentsCategoryPieChart({super.key, required this.items});

  final List<CompLookupGraphCountItemDto> items;

  @override
  State<ComponentsCategoryPieChart> createState() => _ComponentsCategoryPieChartState();
}

class _ComponentsCategoryPieChartState extends State<ComponentsCategoryPieChart> {
  int _activeIndex = -1;
  bool _tooltipFromPie = false;

  static const _sliceRadius = 92.0;

  Color _getColorForCategory(String valueCode) {
    return switch (valueCode) {
      'ALLOWANCE' || 'REMOTE_WORK_ALLOWANCE' || 'CAR_ALLOWANCE' => AppColors.warning,
      'SALARY' || 'BASE_SALARY' => AppColors.error,
      'DEDUCTION' => AppColors.purple,
      'EMPLOYER_CONTRIBUTION' => AppColors.primaryDark,
      'VARIABLE_PAY' || 'COMMISSION' || 'ANNUAL_BONUS' => AppColors.info,
      'BENEFIT' => AppColors.success,
      _ => AppColors.primary,
    };
  }

  void _highlightFromPie(int index) {
    if (_activeIndex == index && _tooltipFromPie) return;
    setState(() {
      _activeIndex = index;
      _tooltipFromPie = index >= 0;
    });
  }

  void _highlightFromLegend(int index) {
    if (_activeIndex == index && !_tooltipFromPie) return;
    setState(() {
      _activeIndex = index;
      _tooltipFromPie = false;
    });
  }

  void _clearHighlight() {
    if (_activeIndex == -1) return;
    setState(() {
      _activeIndex = -1;
      _tooltipFromPie = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final sliceRadius = _sliceRadius.w;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1,
            child: MouseRegion(
              onExit: (_) => _clearHighlight(),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      borderData: FlBorderData(show: false),
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, response) {
                          if (!event.isInterestedForInteractions) {
                            _clearHighlight();
                            return;
                          }

                          final nextIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                          if (nextIndex < 0) {
                            _clearHighlight();
                            return;
                          }

                          _highlightFromPie(nextIndex);
                        },
                      ),
                      sections: [
                        for (var i = 0; i < widget.items.length; i++)
                          PieChartSectionData(
                            color: _getColorForCategory(
                              widget.items[i].valueCode,
                            ).withValues(alpha: _activeIndex == -1 || _activeIndex == i ? 1 : 0.45),
                            value: widget.items[i].count.toDouble(),
                            title: '',
                            radius: sliceRadius,
                            borderSide: BorderSide(
                              color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                              width: 1.2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_activeIndex >= 0 && _tooltipFromPie)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: _PieTooltip(
                            item: (
                              widget.items[_activeIndex].valueName,
                              widget.items[_activeIndex].count.toDouble(),
                              _getColorForCategory(widget.items[_activeIndex].valueCode),
                            ),
                            isDark: isDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.items.length; i++)
                MouseRegion(
                  onEnter: (_) => _highlightFromLegend(i),
                  onExit: (_) => _clearHighlight(),
                  child: Builder(
                    builder: (context) {
                      final color = _getColorForCategory(widget.items[i].valueCode);
                      final item = widget.items[i];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _activeIndex == i ? color.withValues(alpha: isDark ? 0.15 : 0.08) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: _activeIndex == i ? 12.w : 10.w,
                              height: _activeIndex == i ? 12.w : 10.w,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            ),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                item.valueName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: _activeIndex == i ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              item.count.toString(),
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _activeIndex == i ? color : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PieTooltip extends StatelessWidget {
  const _PieTooltip({required this.item, required this.isDark});

  final (String, double, Color) item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.blackTextColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: item.$3, width: 1.5),
        boxShadow: [
          BoxShadow(color: AppColors.blackTextColor.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2)),
        ],
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
                decoration: BoxDecoration(color: item.$3, shape: BoxShape.circle),
              ),
              Gap(8.w),
              Text(
                item.$1,
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
            'Count: ${item.$2.toInt()}',
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
