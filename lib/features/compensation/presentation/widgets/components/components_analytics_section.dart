import 'package:grc/core/enums/compensation_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../providers/lookups/comp_lookups_provider.dart';
import 'charts/components_calculation_bar_chart.dart';
import 'charts/components_category_pie_chart.dart';
import 'charts/components_chart_card.dart';
import 'charts/components_chart_skeleton_loader.dart';

class ComponentsAnalyticsSection extends ConsumerWidget {
  const ComponentsAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryCountsAsync = ref.watch(compGraphCountsProvider(CompensationLookupType.category.value));
    final calcMethodCountsAsync = ref.watch(compGraphCountsProvider(CompensationLookupType.calculationMethod.value));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        final children = <Widget>[];

        // Category Chart
        if (categoryCountsAsync.isLoading) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Category',
              subtitle: 'Category distribution overview',
              child: ComponentsChartSkeletonLoader(isPie: true),
            ),
          );
        } else if (categoryCountsAsync.hasError) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Category',
              subtitle: 'Category distribution overview',
              child: _buildErrorContent('category', categoryCountsAsync.error),
            ),
          );
        } else if (categoryCountsAsync.hasValue) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Category',
              subtitle: 'Category distribution overview',
              child: ComponentsCategoryPieChart(items: categoryCountsAsync.value!),
            ),
          );
        }

        // Calculation Method Chart
        if (calcMethodCountsAsync.isLoading) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Calculation Method',
              subtitle: 'Fixed amount, percentage, and formula split',
              child: ComponentsChartSkeletonLoader(isPie: false),
            ),
          );
        } else if (calcMethodCountsAsync.hasError) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Calculation Method',
              subtitle: 'Fixed amount, percentage, and formula split',
              child: _buildErrorContent('calculation method', calcMethodCountsAsync.error),
            ),
          );
        } else if (calcMethodCountsAsync.hasValue) {
          children.add(
            ComponentsChartCard(
              title: 'Components by Calculation Method',
              subtitle: 'Fixed amount, percentage, and formula split',
              child: ComponentsCalculationBarChart(items: calcMethodCountsAsync.value!),
            ),
          );
        }

        if (isMobile) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[if (i > 0) Gap(16.h), children[i]],
            ],
          );
        }

        final width = (constraints.maxWidth - 16.w) / 2;
        return Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: children.map((child) => SizedBox(width: width, child: child)).toList(),
        );
      },
    );
  }

  Widget _buildErrorContent(String dataType, Object? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            Gap(12.h),
            Text(
              'Error loading $dataType data',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
