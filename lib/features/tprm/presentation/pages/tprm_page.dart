import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/tprm/presentation/widgets/add_vendor_dialog.dart';
import 'package:grc_web/features/tprm/presentation/widgets/vendor_detail_dialog.dart';

const _kContractIconBg = Color(0xFFF3E8FF);
const _kLowRiskGreen = Color(0xFF00A63E);
const _kMediumRiskAmber = Color(0xFFD08700);
const _kHighRiskRed = Color(0xFFE7000B);
const _kChartBlue = Color(0xFF2563EB);
const _kChartRed = Color(0xFFDC2626);
const _kLinkRiskBg = Color(0xFFF3E8FF);
const _kLinkRiskFg = Color(0xFF6E11B0);

class TprmPage extends StatelessWidget {
  const TprmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TitleBar(),
            SizedBox(height: 24.h),
            const _StatsRow(),
            SizedBox(height: 24.h),
            const _ChartsRow(),
            SizedBox(height: 24.h),
            const _RiskSummaryRow(),
            SizedBox(height: 24.h),
            const _FilterBar(),
            SizedBox(height: 24.h),
            const _VendorsTable(vendors: _vendors),
            SizedBox(height: 24.h),
            const _TprmIntegrationSummary(),
          ],
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  'Third-Party Risk Management (TPRM)',
                  style: textTheme.displaySmall,
                  strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Monitor and assess vendor security risks across the enterprise',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
              ],
            ),
          ),
        AppButton(
          label: 'Add Vendor',
          iconAsset: 'assets/figma/tprm/svg/add_vendor.svg',
          variant: AppButtonVariant.primary,
          iconSize: 16.r,
          onPressed: () => showAddVendorDialog(context: context),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: _StatCard(
              value: '8',
              label: 'Total Vendors',
              iconAsset: 'assets/figma/tprm/svg/stat_vendors.svg',
              iconBg: AppColors.primaryTint,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '4',
              label: 'Critical Vendors',
              iconAsset: 'assets/figma/tprm/svg/stat_critical.svg',
              iconBg: AppColors.statusCriticalBg,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: r'$8.5M',
              label: 'Total Contract Value',
              iconAsset: 'assets/figma/tprm/svg/stat_contract.svg',
              iconBg: _kContractIconBg,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '4',
              label: 'Open Issues',
              iconAsset: 'assets/figma/tprm/svg/stat_issues.svg',
              iconBg: AppColors.statusHighBg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.iconAsset,
    required this.iconBg,
  });

  final String value;
  final String label;
  final String iconAsset;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(iconAsset, width: 20.r, height: 20.r),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.072,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
              fontWeight: FontWeight.w400,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

class _ChartsRow extends StatelessWidget {
  const _ChartsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _ChartCard(title: 'Vendor Risk Trend', child: _VendorRiskTrendChart())),
        SizedBox(width: 24.w),
        Expanded(child: _ChartCard(title: 'Risk Distribution by Tier', child: _RiskDistributionChart())),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
              height: 28 / 18,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 250.h, child: child),
        ],
      ),
    );
  }
}

class _VendorRiskTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const axisStyle = TextStyle(
      fontSize: 16,
      height: 1,
      color: Color(0xFF666666),
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 10.w, top: 6.h, bottom: 44.h),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 3,
              minY: 0,
              maxY: 80,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.chartGrid.withValues(alpha: 0.6),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: AppColors.chartGrid.withValues(alpha: 0.6),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Color(0xFF9CA3AF)),
                  bottom: BorderSide(color: Color(0xFF9CA3AF)),
                  top: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32.w,
                    interval: 20,
                    getTitlesWidget: (value, _) => Text('${value.toInt()}', style: axisStyle.copyWith(fontSize: 16.sp)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28.h,
                    getTitlesWidget: (value, _) {
                      const labels = ['Jan', 'Feb', 'Mar', 'Apr'];
                      final i = value.toInt();
                      if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                      return Text(labels[i], style: axisStyle.copyWith(fontSize: 16.sp));
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 75),
                    FlSpot(1, 72),
                    FlSpot(2, 73),
                    FlSpot(3, 78),
                  ],
                  isCurved: true,
                  color: _kChartBlue,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 5),
                    FlSpot(1, 5),
                    FlSpot(2, 5),
                    FlSpot(3, 5),
                  ],
                  isCurved: true,
                  color: _kChartRed,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegendItem(
                iconAsset: 'assets/figma/tprm/svg/chart_legend_avg.svg',
                label: 'Avg Risk Rating',
                color: _kChartBlue,
              ),
              SizedBox(width: 10.w),
              _ChartLegendItem(
                iconAsset: 'assets/figma/tprm/svg/chart_legend_critical.svg',
                label: 'Critical Vendors',
                color: _kChartRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const axisStyle = TextStyle(
      fontSize: 16,
      height: 1,
      color: Color(0xFF666666),
    );

    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 10.w, top: 6.h, bottom: 8.h),
      child: BarChart(
        BarChartData(
          maxY: 4,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.chartGrid.withValues(alpha: 0.6),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Color(0xFF9CA3AF)),
              bottom: BorderSide(color: Color(0xFF9CA3AF)),
              top: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24.w,
                interval: 1,
                getTitlesWidget: (value, _) => Text('${value.toInt()}', style: axisStyle.copyWith(fontSize: 16.sp)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.h,
                getTitlesWidget: (value, _) {
                  const labels = ['Critical', 'Important', 'Standard'];
                  final i = value.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                  return Text(labels[i], style: axisStyle.copyWith(fontSize: 16.sp));
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 4, color: _kChartBlue, width: 56.w, borderRadius: BorderRadius.zero),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 3, color: _kChartBlue, width: 56.w, borderRadius: BorderRadius.zero),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 1, color: _kChartBlue, width: 56.w, borderRadius: BorderRadius.zero),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  const _ChartLegendItem({
    required this.iconAsset,
    required this.label,
    required this.color,
  });

  final String iconAsset;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 14.r,
          height: 14.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: color,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: -0.32,
          ),
        ),
      ],
    );
  }
}

class _RiskSummaryRow extends StatelessWidget {
  const _RiskSummaryRow();

  static const _items = [
    _RiskSummaryItem(label: 'Low Risk', count: 3, fillFraction: 0.375, color: _kLowRiskGreen, countColor: _kLowRiskGreen),
    _RiskSummaryItem(label: 'Medium Risk', count: 4, fillFraction: 0.5, color: _kMediumRiskAmber, countColor: _kMediumRiskAmber),
    _RiskSummaryItem(label: 'High Risk', count: 1, fillFraction: 0.125, color: _kHighRiskRed, countColor: _kHighRiskRed),
  ];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) SizedBox(width: 16.w),
            Expanded(child: _RiskSummaryCard(item: _items[i])),
          ],
        ],
      ),
    );
  }
}

class _RiskSummaryItem {
  const _RiskSummaryItem({
    required this.label,
    required this.count,
    required this.fillFraction,
    required this.color,
    required this.countColor,
  });

  final String label;
  final int count;
  final double fillFraction;
  final Color color;
  final Color countColor;
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({required this.item});

  final _RiskSummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                item.label,
                style: TextStyle(
                  color: AppColors.textLabel,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
              const Spacer(),
              Text(
                '${item.count}',
                style: TextStyle(
                  color: item.countColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: item.fillFraction,
              minHeight: 8.h,
              backgroundColor: AppColors.border,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatefulWidget {
  const _FilterBar();

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 17.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _searchController,
              hint: 'Search vendors...',
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 9.w),
                child: SvgPicture.asset(
                  'assets/figma/assets/svg/search.svg',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(41.w, 11.5.h, 17.w, 11.5.h),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 126.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => 'All Tiers',
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 157.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => 'All Risk Levels',
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: 'Export',
            iconAsset: 'assets/figma/assets/svg/export.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 16.r,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _VendorsTable extends StatelessWidget {
  const _VendorsTable({required this.vendors});

  final List<_VendorItem> vendors;

  static const _colWidths = <double>[
    114.69,
    281.09,
    163.88,
    120.55,
    135.34,
    124.73,
    171.73,
    82.06,
    159.77,
    124.17,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableMinWidth = _colWidths.fold<double>(0, (s, w) => s + w.w);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth.clamp(tableMinWidth, double.infinity),
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (var i = 0; i < _colWidths.length; i++)
                    i: FixedColumnWidth(_colWidths[i].w),
                },
                children: [
                  _headerRow(context),
                  for (final vendor in vendors) _dataRow(context, vendor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _headerRow(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textLabel,
          fontWeight: FontWeight.w500,
        );

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: [
        _headerCell('Vendor ID', style),
        _headerCell('Name', style),
        _headerCell('Category', style),
        _headerCell('Tier', style),
        _headerCell('Risk Rating', style),
        _headerCell('Risk Level', style),
        _headerCell('Links', style),
        _headerCell('Issues', style),
        _headerCell('Last Assessment', style),
        _headerCell('Actions', style),
      ],
    );
  }

  TableRow _dataRow(BuildContext context, _VendorItem vendor) {
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.rowDivider)),
      ),
      children: [
        _idCell(vendor.id),
        _nameCell(vendor.name),
        _categoryCell(vendor.category),
        _tierCell(vendor.tier),
        _riskRatingCell(vendor.riskRating),
        _riskLevelCell(vendor.riskLevel),
        _linksCell(vendor.links),
        _issuesCell(vendor.issues),
        _categoryCell(vendor.lastAssessment),
        _actionsCell(context, vendor),
      ],
    );
  }

  Widget _headerCell(String label, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Text(
        label,
        style: style,
        strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
        textHeightBehavior: AppTextMetrics.textHeight,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _idCell(String id) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.5.h, 16.w, 12.5.h),
      child: Text(
        id,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 24 / 16,
          letterSpacing: -0.32,
        ),
      ),
    );
  }

  Widget _nameCell(String name) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.25.h, 16.w, 14.75.h),
      child: Text(
        name,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
          letterSpacing: -0.154,
        ),
      ),
    );
  }

  Widget _categoryCell(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.25.h, 16.w, 14.75.h),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textLabel,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          letterSpacing: -0.154,
        ),
      ),
    );
  }

  Widget _tierCell(_VendorTier tier) {
    final (bg, fg) = switch (tier) {
      _VendorTier.critical => (AppColors.statusCriticalBg, AppColors.statusCriticalFg),
      _VendorTier.important => (AppColors.statusHighBg, AppColors.statusHighFg),
      _VendorTier.standard => (AppColors.chipNeutralBg, AppColors.textBody),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 13.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            tier.label,
            style: TextStyle(
              color: fg,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _riskRatingCell(int rating) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Row(
        children: [
          SizedBox(
            width: 64.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: rating / 100,
                minHeight: 8.h,
                backgroundColor: AppColors.border,
                color: _kLowRiskGreen,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$rating',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
            maxLines: 1,
            softWrap: false,
          ),
        ],
      ),
    );
  }

  Widget _riskLevelCell(_RiskLevel level) {
    final (bg, fg) = switch (level) {
      _RiskLevel.low => (AppColors.statusLowBg, AppColors.statusLowFg),
      _RiskLevel.medium => (AppColors.statusMediumBg, AppColors.statusMediumFg),
      _RiskLevel.high => (AppColors.statusCriticalBg, AppColors.statusCriticalFg),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 13.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            level.label,
            style: TextStyle(
              color: fg,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  Widget _linksCell(_VendorLinks links) {
    final badges = <Widget>[
      if (links.risks > 0)
        _LinkBadge(
          count: links.risks,
          bg: _kLinkRiskBg,
          fg: _kLinkRiskFg,
          iconAsset: 'assets/figma/tprm/svg/link_risk.svg',
        ),
      if (links.assets > 0)
        _LinkBadge(
          count: links.assets,
          bg: AppColors.statusCriticalBg,
          fg: AppColors.statusCriticalFg,
          iconAsset: 'assets/figma/tprm/svg/link_asset.svg',
        ),
      if (links.assessments > 0)
        _LinkBadge(
          count: links.assessments,
          bg: AppColors.primaryTint,
          fg: AppColors.weightBadgeFg,
          iconAsset: 'assets/figma/tprm/svg/link_assessment.svg',
        ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Wrap(spacing: 4.w, runSpacing: 4.h, children: badges),
    );
  }

  Widget _issuesCell(int issues) {
    if (issues == 0) {
      return SizedBox(height: 49.h);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.5.h, 16.w, 14.5.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _LinkBadge(
          count: issues,
          bg: AppColors.statusCriticalBg,
          fg: AppColors.statusCriticalFg,
          iconAsset: 'assets/figma/tprm/svg/link_issue.svg',
        ),
      ),
    );
  }

  Widget _actionsCell(BuildContext context, _VendorItem vendor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.5.h, 16.w, 12.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TableIconButton(
            iconAsset: 'assets/figma/tprm/svg/action_view.svg',
            onTap: () => showVendorDetailDialog(
              context: context,
              data: _vendorDetailDataFor(vendor),
            ),
          ),
          SizedBox(width: 4.w),
          _TableIconButton(
            iconAsset: 'assets/figma/tprm/svg/action_edit.svg',
            onTap: () => showEditVendorDialog(
              context: context,
              data: _vendorFormDataFor(vendor),
            ),
          ),
          SizedBox(width: 4.w),
          _TableIconButton(iconAsset: 'assets/figma/tprm/svg/action_link.svg'),
        ],
      ),
    );
  }

  VendorDetailData _vendorDetailDataFor(_VendorItem vendor) {
    if (vendor.id == 'VND-001') {
      return VendorDetailData.sample();
    }

    return VendorDetailData(
      id: vendor.id,
      name: vendor.name,
      category: vendor.category,
      tierLabel: vendor.tier.label,
      riskRating: vendor.riskRating,
      riskLevelLabel: '${vendor.riskLevel.label} Risk',
      contractValue: '—',
      controlEffectiveness: vendor.riskRating,
      openIssuesCount: vendor.issues,
      businessOwner: '—',
      vendorManager: '—',
      geography: '—',
      dataAccess: '—',
      servicesProvided: vendor.category,
      lastAssessment: vendor.lastAssessment,
      nextAssessment: '—',
      inherentRisk: vendor.riskRating,
      residualRisk: (vendor.riskRating * 0.3).round(),
      riskReduction: (vendor.riskRating * 0.7).round(),
      assessmentScores: const [
        VendorAssessmentScore(label: 'Info Security', value: 70),
        VendorAssessmentScore(label: 'Data Privacy', value: 65),
        VendorAssessmentScore(label: 'Cloud Security', value: 72),
        VendorAssessmentScore(label: 'Ops Resilience', value: 68),
        VendorAssessmentScore(label: 'Financial', value: 75),
      ],
      certifications: const [],
      linkedAssets: [
        for (var i = 0; i < vendor.links.assets; i++)
          'AST-${(i + 1).toString().padLeft(3, '0')}',
      ],
      linkedRisks: [
        for (var i = 0; i < vendor.links.risks; i++)
          'R-${(i + 1).toString().padLeft(3, '0')}',
      ],
      linkedControls: const [],
      linkedPrograms: const [],
      openIssues: vendor.issues > 0
          ? [
              VendorOpenIssue(
                id: 'ISS-${vendor.id.split('-').last}',
                severity: vendor.riskLevel.label,
                title: 'Pending vendor review item',
                dueDate: vendor.lastAssessment,
                status: 'Open',
              ),
            ]
          : const [],
      slaAvailability: 99.0,
      slaResponseTime: 95,
      slaIncidentResolution: 93,
    );
  }

  VendorFormData _vendorFormDataFor(_VendorItem vendor) {
    if (vendor.id == 'VND-001') {
      return VendorFormData.fromDetail(VendorDetailData.sample());
    }

    return VendorFormData(
      id: vendor.id,
      name: vendor.name,
      category: _categoryKeyFor(vendor.category),
      tier: _tierKeyFor(vendor.tier),
      dataAccessLevel: 'internal',
      status: 'active',
      geography: '',
      businessOwner: '',
      servicesProvided: vendor.category,
      riskRating: vendor.riskRating,
      riskLevel: _riskLevelKeyFor(vendor.riskLevel),
      inherentRisk: vendor.riskRating,
      residualRisk: (vendor.riskRating * 0.3).round(),
      controlEffectiveness: vendor.riskRating,
      contractValue: 0,
      annualSpend: 0,
      vendorManager: '',
      lastAssessment: DateTime.tryParse(vendor.lastAssessment),
      nextAssessment: null,
      linkedAssets: [
        for (var i = 0; i < vendor.links.assets; i++)
          'AST-${(i + 1).toString().padLeft(3, '0')}',
      ].join(', '),
      linkedRisks: [
        for (var i = 0; i < vendor.links.risks; i++)
          'R-${(i + 1).toString().padLeft(3, '0')}',
      ].join(', '),
      linkedControls: '',
      linkedPrograms: '',
      certifications: const {},
      infoSecurityScore: 0,
      dataPrivacyScore: 0,
      cloudSecurityScore: 0,
      operationalResilienceScore: 0,
      financialStabilityScore: 0,
    );
  }

  String _categoryKeyFor(String category) {
    return switch (category) {
      'Cloud Provider' => 'cloudProvider',
      'Financial Services' => 'financialServices',
      'SaaS' => 'saas',
      'Security' => 'security',
      'Infrastructure' => 'infrastructure',
      _ => '',
    };
  }

  String _tierKeyFor(_VendorTier tier) {
    return switch (tier) {
      _VendorTier.critical => 'critical',
      _VendorTier.important => 'important',
      _VendorTier.standard => 'standard',
    };
  }

  String _riskLevelKeyFor(_RiskLevel level) {
    return switch (level) {
      _RiskLevel.medium => 'medium',
      _RiskLevel.high => 'high',
      _RiskLevel.low => 'low',
    };
  }
}

class _TprmIntegrationSummary extends StatelessWidget {
  const _TprmIntegrationSummary();

  static const _cards = [
    _IntegrationStatCard(
      value: '8',
      label: 'Assets Covered',
      iconAsset: 'assets/figma/tprm/svg/integration_assets.svg',
      iconBg: _kContractIconBg,
    ),
    _IntegrationStatCard(
      value: '6',
      label: 'Vendor Risks',
      iconAsset: 'assets/figma/tprm/svg/integration_risks.svg',
      iconBg: AppColors.statusCriticalBg,
    ),
    _IntegrationStatCard(
      value: '4',
      label: 'Control Links',
      iconAsset: 'assets/figma/tprm/svg/integration_controls.svg',
      iconBg: AppColors.primaryTint,
    ),
    _IntegrationStatCard(
      value: '2',
      label: 'Program Links',
      iconAsset: 'assets/figma/tprm/svg/integration_programs.svg',
      iconBg: AppColors.statusLowBg,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLightBg, Color(0xFFFAF5FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TPRM Integration Summary',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
              height: 28 / 18,
            ),
          ),
          SizedBox(height: 16.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < _cards.length; i++) ...[
                  if (i > 0) SizedBox(width: 16.w),
                  Expanded(child: _IntegrationStatCardWidget(data: _cards[i])),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntegrationStatCard {
  const _IntegrationStatCard({
    required this.value,
    required this.label,
    required this.iconAsset,
    required this.iconBg,
  });

  final String value;
  final String label;
  final String iconAsset;
  final Color iconBg;
}

class _IntegrationStatCardWidget extends StatelessWidget {
  const _IntegrationStatCardWidget({required this.data});

  final _IntegrationStatCard data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(data.iconAsset, width: 20.r, height: 20.r),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.value,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.072,
                  height: 32 / 24,
                ),
              ),
              Text(
                data.label,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkBadge extends StatelessWidget {
  const _LinkBadge({
    required this.count,
    required this.bg,
    required this.fg,
    required this.iconAsset,
  });

  final int count;
  final Color bg;
  final Color fg;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconAsset, width: 14.r, height: 14.r),
          SizedBox(width: 4.w),
          Text(
            '$count',
            style: TextStyle(
              color: fg,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableIconButton extends StatelessWidget {
  const _TableIconButton({required this.iconAsset, this.onTap});

  final String iconAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: SvgPicture.asset(iconAsset, width: 22.r, height: 22.r),
        ),
      ),
    );
  }
}

enum _VendorTier {
  critical('Critical'),
  important('Important'),
  standard('Standard');

  const _VendorTier(this.label);
  final String label;
}

enum _RiskLevel {
  low('Low'),
  medium('Medium'),
  high('High');

  const _RiskLevel(this.label);
  final String label;
}

class _VendorLinks {
  const _VendorLinks({this.risks = 0, this.assets = 0, this.assessments = 0});

  final int risks;
  final int assets;
  final int assessments;
}

class _VendorItem {
  const _VendorItem({
    required this.id,
    required this.name,
    required this.category,
    required this.tier,
    required this.riskRating,
    required this.riskLevel,
    required this.links,
    required this.issues,
    required this.lastAssessment,
  });

  final String id;
  final String name;
  final String category;
  final _VendorTier tier;
  final int riskRating;
  final _RiskLevel riskLevel;
  final _VendorLinks links;
  final int issues;
  final String lastAssessment;
}

const _vendors = <_VendorItem>[
  _VendorItem(
    id: 'VND-001',
    name: 'Cloud Infrastructure Services Inc.',
    category: 'Cloud Provider',
    tier: _VendorTier.critical,
    riskRating: 85,
    riskLevel: _RiskLevel.low,
    links: _VendorLinks(risks: 2, assets: 1, assessments: 1),
    issues: 1,
    lastAssessment: '2026-04-15',
  ),
  _VendorItem(
    id: 'VND-002',
    name: 'Payment Processing Solutions',
    category: 'Financial Services',
    tier: _VendorTier.critical,
    riskRating: 78,
    riskLevel: _RiskLevel.medium,
    links: _VendorLinks(risks: 1, assets: 1, assessments: 1),
    issues: 0,
    lastAssessment: '2026-03-20',
  ),
  _VendorItem(
    id: 'VND-003',
    name: 'Analytics Platform Co.',
    category: 'SaaS',
    tier: _VendorTier.important,
    riskRating: 72,
    riskLevel: _RiskLevel.medium,
    links: _VendorLinks(risks: 1),
    issues: 1,
    lastAssessment: '2026-02-10',
  ),
  _VendorItem(
    id: 'VND-004',
    name: 'Security Monitoring Services',
    category: 'Security',
    tier: _VendorTier.critical,
    riskRating: 88,
    riskLevel: _RiskLevel.low,
    links: _VendorLinks(risks: 1, assets: 2, assessments: 1),
    issues: 0,
    lastAssessment: '2026-04-01',
  ),
  _VendorItem(
    id: 'VND-005',
    name: 'Document Management Systems',
    category: 'SaaS',
    tier: _VendorTier.standard,
    riskRating: 68,
    riskLevel: _RiskLevel.medium,
    links: _VendorLinks(risks: 1),
    issues: 1,
    lastAssessment: '2026-01-15',
  ),
  _VendorItem(
    id: 'VND-006',
    name: 'Email Security Gateway',
    category: 'Security',
    tier: _VendorTier.important,
    riskRating: 75,
    riskLevel: _RiskLevel.medium,
    links: _VendorLinks(risks: 1),
    issues: 0,
    lastAssessment: '2026-03-05',
  ),
  _VendorItem(
    id: 'VND-007',
    name: 'HR Management Platform',
    category: 'SaaS',
    tier: _VendorTier.important,
    riskRating: 58,
    riskLevel: _RiskLevel.high,
    links: _VendorLinks(assets: 2),
    issues: 0,
    lastAssessment: '2025-12-10',
  ),
  _VendorItem(
    id: 'VND-008',
    name: 'Backup & Disaster Recovery',
    category: 'Infrastructure',
    tier: _VendorTier.critical,
    riskRating: 82,
    riskLevel: _RiskLevel.low,
    links: _VendorLinks(risks: 2, assets: 1, assessments: 1),
    issues: 0,
    lastAssessment: '2026-04-20',
  ),
];
