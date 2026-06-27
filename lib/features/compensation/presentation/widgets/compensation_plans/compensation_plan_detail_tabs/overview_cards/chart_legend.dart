import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LegendItemData {
  final String label;
  final Color color;
  final bool isLine;

  const LegendItemData({required this.label, required this.color, this.isLine = false});
}

class ChartLegend extends StatelessWidget {
  final List<LegendItemData> items;

  const ChartLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.w,
      runSpacing: 8.h,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                item.isLine
                    ? SizedBox(
                        width: 14.w,
                        child: Divider(color: item.color, thickness: 2, height: 2),
                      )
                    : Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                      ),
                Gap(4.w),
                Text(
                  item.label,
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 16.sp, color: item.color),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
