import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_responsive_table.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/controls/presentation/widgets/add_control_dialog.dart';
import 'package:grc_web/features/controls/presentation/widgets/control_detail_dialog.dart';

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

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
            const _FrameworkCoverageCard(),
            SizedBox(height: 24.h),
            const _FilterBar(),
            SizedBox(height: 24.h),
            const _ControlsTable(controls: _controls),
            SizedBox(height: 24.h),
            const _IntegrationSection(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title bar
// ---------------------------------------------------------------------------

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Controls',
                style: textTheme.displaySmall,
                strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage controls mapped to ISO 27001, NIST CSF, and CIS',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textBody),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
        ),
        AppButton(
          label: 'Add Control',
          iconAsset: 'assets/figma/controls/svg/add_control.svg',
          variant: AppButtonVariant.primary,
          iconSize: 28.r,
          onPressed: () => showAddControlDialog(context: context),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _StatCard(
            value: '10',
            label: 'Total Controls',
            iconAsset: 'assets/figma/controls/svg/stat_check.svg',
            iconBg: AppColors.primaryTint,
          ),
        ),
        SizedBox(width: 16.w),
        const Expanded(
          child: _StatCard(
            value: '9',
            label: 'Implemented',
            iconAsset: 'assets/figma/controls/svg/stat_check.svg',
            iconBg: AppColors.primaryTint,
          ),
        ),
        SizedBox(width: 16.w),
        const Expanded(
          child: _StatCard(
            value: '86%',
            label: 'Avg Effectiveness',
            iconAsset: 'assets/figma/controls/svg/stat_check.svg',
            iconBg: AppColors.primaryTint,
          ),
        ),
        SizedBox(width: 16.w),
        const Expanded(
          child: _StatCard(
            value: '1',
            label: 'Pending',
            iconAsset: 'assets/figma/controls/svg/stat_pending.svg',
            iconBg: AppColors.statusHighBg,
          ),
        ),
      ],
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
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(iconAsset, width: 32.r, height: 32.r),
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

// ---------------------------------------------------------------------------
// Framework coverage
// ---------------------------------------------------------------------------

class _FrameworkCoverageCard extends StatelessWidget {
  const _FrameworkCoverageCard();

  static const _frameworks = <_FrameworkCoverage>[
    _FrameworkCoverage(name: 'ISO 27001', mapped: 98, total: 114),
    _FrameworkCoverage(name: 'NIST CSF', mapped: 92, total: 108),
    _FrameworkCoverage(name: 'CIS Controls', mapped: 124, total: 153),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Framework Coverage',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < _frameworks.length; i++) ...[
            _FrameworkRow(data: _frameworks[i]),
            if (i != _frameworks.length - 1) SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}

class _FrameworkRow extends StatelessWidget {
  const _FrameworkRow({required this.data});

  final _FrameworkCoverage data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (data.mapped / data.total * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              data.name,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textBody,
                fontWeight: FontWeight.w400,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
            const Spacer(),
            Text(
              '${data.mapped} / ${data.total} ($percent%)',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textBody,
                fontWeight: FontWeight.w400,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: data.mapped / data.total,
            minHeight: 8.h,
            backgroundColor: AppColors.chipTagBg,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

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
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppTextField.search(
              controller: _searchController,
              hint: 'Search controls...',
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 130.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => 'All Types',
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 211.w,
            child: AppSelectField<String>(
              value: 'all',
              items: const ['all'],
              itemLabel: (_) => 'All Status',
              onChanged: (_) {},
              contentPadding: EdgeInsets.fromLTRB(21.w, 9.h, 12.w, 9.h),
            ),
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: 'More Filters',
            iconAsset: 'assets/figma/assets/svg/filter.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 28.r,
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          AppButton(
            label: 'Export',
            iconAsset: 'assets/figma/assets/svg/export.svg',
            variant: AppButtonVariant.outlined,
            iconSize: 28.r,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Controls table
// ---------------------------------------------------------------------------

class _ControlsTable extends StatelessWidget {
  const _ControlsTable({required this.controls});

  final List<_ControlItem> controls;

  static final _layout = AppResponsiveTableLayout(
    columns: [
      AppTableColumnSpec(minWidth: 89.96, dropPriority: 0), // Control ID
      AppTableColumnSpec(minWidth: 226.30, dropPriority: 0), // Name
      AppTableColumnSpec(minWidth: 112.89, dropPriority: 6), // Type
      AppTableColumnSpec(minWidth: 180.00, dropPriority: 10), // Links
      AppTableColumnSpec(minWidth: 225.23, dropPriority: 9), // Framework Mapping
      AppTableColumnSpec(minWidth: 135.42, dropPriority: 4), // Effectiveness
      AppTableColumnSpec(minWidth: 153.82, dropPriority: 3), // Status
      AppTableColumnSpec(minWidth: 120.23, dropPriority: 5), // Owner
      AppTableColumnSpec(minWidth: 111.90, dropPriority: 7), // Last Assessed
      AppTableColumnSpec(minWidth: 120.02, dropPriority: 0), // Actions
    ],
  );

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
          final visible = _layout.visibleIndicesForWidth(constraints.maxWidth);
          final tableMinWidth = _layout.minWidthForIndices(visible);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth.clamp(
                  tableMinWidth,
                  double.infinity,
                ),
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: _layout.columnWidthsForIndices(visible),
                children: [
                  _headerRow(context, visible),
                  for (final control in controls)
                    _dataRow(context, control, visible),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _headerRow(BuildContext context, List<int> visible) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textLabel,
          fontWeight: FontWeight.w500,
        );

    final cells = [
      _headerCell('Control ID', style),
      _headerCell('Name', style),
      _headerCell('Type', style),
      _headerCell('Links', style),
      _headerCell('Framework Mapping', style),
      _headerCell('Effectiveness', style),
      _headerCell('Status', style),
      _headerCell('Owner', style),
      _headerCell('Last Assessed', style),
      _headerCell('Actions', style),
    ];

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: _layout.cellsForIndices(cells, visible),
    );
  }

  TableRow _dataRow(BuildContext context, _ControlItem control, List<int> visible) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.textLabel,
      fontWeight: FontWeight.w400,
    );
    final captionStyle = textTheme.labelSmall?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w400,
    );

    final cells = [
        _idCell(context, control),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                control.name,
                style: bodyStyle,
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              SizedBox(height: 2.h),
              Text(
                control.description,
                style: captionStyle,
                strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
        ),
        _typeCell(control.type),
        _linksCell(control.links),
        _frameworkCell(control.frameworks),
        _effectivenessCell(control.effectiveness),
        _statusCell(control.status),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Text(
            control.owner,
            style: bodyStyle,
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Text(
            control.lastAssessed,
            style: bodyStyle,
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ),
        _actionsCell(context, control),
      ];

    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.rowDivider)),
      ),
      children: _layout.cellsForIndices(cells, visible),
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
      ),
    );
  }

  Widget _idCell(BuildContext context, _ControlItem control) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: InkWell(
        onTap: () => _openControlDetail(context, control),
        child: Text(
          control.id,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ),
    );
  }

  void _openControlEdit(BuildContext context, _ControlItem control) {
    final statusKey = switch (control.status) {
      _ControlStatus.implemented => 'implemented',
      _ControlStatus.partiallyImplemented => 'partiallyImplemented',
    };
    final typeKey = switch (control.type) {
      _ControlType.preventive => 'preventive',
      _ControlType.detective => 'detective',
      _ControlType.corrective => 'corrective',
    };

    showEditControlDialog(
      context: context,
      data: ControlFormData.fromSummary(
        id: control.id,
        name: control.name,
        description: control.description,
        controlType: typeKey,
        status: statusKey,
        owner: control.owner,
        frameworks: control.frameworks,
        effectiveness: control.effectiveness,
        riskLinks: control.links.risks,
        assetLinks: control.links.assets,
        assessmentLinks: control.links.assessments,
      ),
    );
  }

  void _openControlDetail(BuildContext context, _ControlItem control) {
    final (statusBg, statusFg, statusLabel) = switch (control.status) {
      _ControlStatus.implemented => (
          AppColors.statusLowBg,
          AppColors.statusLowFg,
          'Implemented',
        ),
      _ControlStatus.partiallyImplemented => (
          AppColors.statusMediumBg,
          AppColors.statusMediumFg,
          'Partially Implemented',
        ),
    };

    showControlDetailDialog(
      context: context,
      data: ControlDetailData.sample(
        id: control.id,
        name: control.name,
        description: control.description,
        typeLabel: control.type.label,
        statusLabel: statusLabel,
        statusBg: statusBg,
        statusFg: statusFg,
        owner: control.owner,
        lastAssessed: control.lastAssessed,
        frameworks: control.frameworks,
        effectiveness: control.effectiveness,
        riskLinks: control.links.risks,
        assetLinks: control.links.assets,
        assessmentLinks: control.links.assessments,
      ),
    );
  }

  Widget _typeCell(_ControlType type) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.chipNeutralBg,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          type.label,
          style: TextStyle(
            color: AppColors.textBody,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }

  Widget _linksCell(_ControlLinks links) {
    final badges = <Widget>[
      if (links.risks > 0)
        _LinkBadge(
          count: links.risks,
          bg: AppColors.statusCriticalBg,
          fg: AppColors.statusCriticalFg,
          iconAsset: 'assets/figma/controls/svg/link_risk.svg',
        ),
      if (links.assets > 0)
        _LinkBadge(
          count: links.assets,
          bg: AppColors.primaryTint,
          fg: AppColors.weightBadgeFg,
          iconAsset: 'assets/figma/controls/svg/link_asset.svg',
        ),
      if (links.assessments > 0)
        _LinkBadge(
          count: links.assessments,
          bg: AppColors.primaryTint,
          fg: AppColors.weightBadgeFg,
          iconAsset: 'assets/figma/controls/svg/link_assessment.svg',
        ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 4.h,
        children: badges,
      ),
    );
  }

  Widget _frameworkCell(List<String> frameworks) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 4.h,
        children: [
          for (final fw in frameworks)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.chipNeutralBg,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                fw,
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _effectivenessCell(int percent) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 8.h,
                backgroundColor: AppColors.chipTagBg,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 32.w,
            child: Text(
              '$percent%',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCell(_ControlStatus status) {
    final (bg, fg, label) = switch (status) {
      _ControlStatus.implemented => (
          AppColors.statusLowBg,
          AppColors.statusLowFg,
          'Implemented',
        ),
      _ControlStatus.partiallyImplemented => (
          AppColors.statusMediumBg,
          AppColors.statusMediumFg,
          'Partially Implemented',
        ),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }

  Widget _actionsCell(BuildContext context, _ControlItem control) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TableIconButton(
            iconAsset: 'assets/figma/controls/svg/action_view.svg',
            onPressed: () => _openControlDetail(context, control),
          ),
          SizedBox(width: 8.w),
          _TableIconButton(
            iconAsset: 'assets/figma/controls/svg/action_edit.svg',
            onPressed: () => _openControlEdit(context, control),
          ),
          SizedBox(width: 8.w),
          _TableIconButton(
            iconAsset: 'assets/figma/controls/svg/action_link.svg',
            onPressed: () {},
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconAsset, width: 24.r, height: 24.r),
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
  const _TableIconButton({
    required this.iconAsset,
    this.onPressed,
  });

  final String iconAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(2.r),
          child: SvgPicture.asset(iconAsset, width: 32.r, height: 32.r),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Integration section
// ---------------------------------------------------------------------------

class _IntegrationSection extends StatelessWidget {
  const _IntegrationSection();

  static const _cards = <_IntegrationCard>[
    _IntegrationCard(
      value: '23',
      title: 'Asset Links',
      subtitle: 'Controls protecting assets',
      iconAsset: 'assets/figma/controls/svg/integration_asset.svg',
      iconBg: AppColors.primaryTint,
    ),
    _IntegrationCard(
      value: '20',
      title: 'Risk Mitigations',
      subtitle: 'Risks being controlled',
      iconAsset: 'assets/figma/controls/svg/integration_risk.svg',
      iconBg: AppColors.statusCriticalBg,
    ),
    _IntegrationCard(
      value: '11',
      title: 'Assessment Links',
      subtitle: 'Framework assessments',
      iconAsset: 'assets/figma/controls/svg/integration_assessment.svg',
      iconBg: AppColors.primaryTint,
    ),
    _IntegrationCard(
      value: '15',
      title: 'Evidence Items',
      subtitle: 'Documentation collected',
      iconAsset: 'assets/figma/controls/svg/integration_evidence.svg',
      iconBg: AppColors.primaryTint,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/figma/controls/svg/integration_header.svg',
                width: 32.r,
                height: 32.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Control Integration & Coverage',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.45,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              for (var i = 0; i < _cards.length; i++) ...[
                Expanded(child: _IntegrationStatCard(data: _cards[i])),
                if (i != _cards.length - 1) SizedBox(width: 16.w),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DistributionCard(
                  title: 'Control Type Distribution',
                  rows: const [
                    _DistributionRow(label: 'Preventive', value: '4 (40%)'),
                    _DistributionRow(label: 'Detective', value: '4 (40%)'),
                    _DistributionRow(label: 'Corrective', value: '2 (20%)'),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _DistributionCard(
                  title: 'Testing Status',
                  rows: const [
                    _DistributionRow(label: 'Continuous Monitoring', value: '5 controls'),
                    _DistributionRow(label: 'Periodic Testing', value: '5 controls'),
                    _DistributionRow(label: 'Avg Days Since Test', value: '50 days'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntegrationStatCard extends StatelessWidget {
  const _IntegrationStatCard({required this.data});

  final _IntegrationCard data;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(data.iconAsset, width: 32.r, height: 32.r),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.value,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.072,
                    ),
                    strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                    textHeightBehavior: AppTextMetrics.textHeight,
                  ),
                  Text(
                    data.title,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textBody,
                      fontWeight: FontWeight.w400,
                    ),
                    strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                    textHeightBehavior: AppTextMetrics.textHeight,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            data.subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_DistributionRow> rows;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.154,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 12.h),
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              children: [
                Text(
                  rows[i].label,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textBody,
                    fontWeight: FontWeight.w400,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
                const Spacer(),
                Text(
                  rows[i].value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.154,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
              ],
            ),
            if (i != rows.length - 1) SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models & mock data
// ---------------------------------------------------------------------------

enum _ControlType {
  preventive('Preventive'),
  detective('Detective'),
  corrective('Corrective');

  const _ControlType(this.label);
  final String label;
}

enum _ControlStatus { implemented, partiallyImplemented }

class _ControlLinks {
  const _ControlLinks({
    required this.risks,
    required this.assets,
    required this.assessments,
  });

  final int risks;
  final int assets;
  final int assessments;
}

class _ControlItem {
  const _ControlItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.links,
    required this.frameworks,
    required this.effectiveness,
    required this.status,
    required this.owner,
    required this.lastAssessed,
  });

  final String id;
  final String name;
  final String description;
  final _ControlType type;
  final _ControlLinks links;
  final List<String> frameworks;
  final int effectiveness;
  final _ControlStatus status;
  final String owner;
  final String lastAssessed;
}

class _FrameworkCoverage {
  const _FrameworkCoverage({
    required this.name,
    required this.mapped,
    required this.total,
  });

  final String name;
  final int mapped;
  final int total;
}

class _IntegrationCard {
  const _IntegrationCard({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.iconBg,
  });

  final String value;
  final String title;
  final String subtitle;
  final String iconAsset;
  final Color iconBg;
}

class _DistributionRow {
  const _DistributionRow({required this.label, required this.value});

  final String label;
  final String value;
}

const _controls = <_ControlItem>[
  _ControlItem(
    id: 'CTL-001',
    name: 'Multi-Factor Authentication',
    description: 'Enforce MFA for all user accounts',
    type: _ControlType.preventive,
    links: _ControlLinks(risks: 2, assets: 2, assessments: 2),
    frameworks: ['ISO 27001: A.9.4.2', 'NIST: PR.AC-7', 'CIS: 6.3'],
    effectiveness: 95,
    status: _ControlStatus.implemented,
    owner: 'Security Team',
    lastAssessed: '2026-04-15',
  ),
  _ControlItem(
    id: 'CTL-002',
    name: 'Data Encryption at Rest',
    description: 'Encrypt all sensitive data stored in databases',
    type: _ControlType.preventive,
    links: _ControlLinks(risks: 2, assets: 3, assessments: 1),
    frameworks: ['ISO 27001: A.10.1.1', 'NIST: PR.DS-1', 'CIS: 13.1'],
    effectiveness: 92,
    status: _ControlStatus.implemented,
    owner: 'Data Team',
    lastAssessed: '2026-04-20',
  ),
  _ControlItem(
    id: 'CTL-003',
    name: 'Cloud Security Posture Management',
    description: 'Continuous monitoring of cloud configurations',
    type: _ControlType.detective,
    links: _ControlLinks(risks: 1, assets: 1, assessments: 1),
    frameworks: ['NIST: DE.CM-8', 'CIS: 1.14'],
    effectiveness: 88,
    status: _ControlStatus.implemented,
    owner: 'Cloud Team',
    lastAssessed: '2026-04-18',
  ),
  _ControlItem(
    id: 'CTL-004',
    name: 'Incident Response Plan',
    description: 'Documented and tested IR procedures',
    type: _ControlType.corrective,
    links: _ControlLinks(risks: 3, assets: 4, assessments: 1),
    frameworks: ['ISO 27001: A.16.1.5', 'NIST: RS.RP-1'],
    effectiveness: 85,
    status: _ControlStatus.implemented,
    owner: 'CISO',
    lastAssessed: '2026-03-30',
  ),
  _ControlItem(
    id: 'CTL-005',
    name: 'Vendor Security Assessment',
    description: 'Quarterly security reviews of critical vendors',
    type: _ControlType.detective,
    links: _ControlLinks(risks: 1, assets: 1, assessments: 1),
    frameworks: ['ISO 27001: A.15.1.1', 'NIST: ID.SC-3'],
    effectiveness: 78,
    status: _ControlStatus.partiallyImplemented,
    owner: 'Procurement',
    lastAssessed: '2026-04-10',
  ),
  _ControlItem(
    id: 'CTL-006',
    name: 'Backup and Recovery',
    description: 'Daily automated backups with tested recovery',
    type: _ControlType.corrective,
    links: _ControlLinks(risks: 2, assets: 4, assessments: 1),
    frameworks: ['ISO 27001: A.12.3.1', 'NIST: PR.IP-4', 'CIS: 10.1'],
    effectiveness: 90,
    status: _ControlStatus.implemented,
    owner: 'IT Operations',
    lastAssessed: '2026-04-22',
  ),
  _ControlItem(
    id: 'CTL-007',
    name: 'Security Awareness Training',
    description: 'Annual mandatory training for all employees',
    type: _ControlType.preventive,
    links: _ControlLinks(risks: 2, assets: 1, assessments: 0),
    frameworks: ['ISO 27001: A.7.2.2', 'NIST: PR.AT-1', 'CIS: 17.2'],
    effectiveness: 72,
    status: _ControlStatus.implemented,
    owner: 'HR & Security',
    lastAssessed: '2026-01-15',
  ),
  _ControlItem(
    id: 'CTL-008',
    name: 'Vulnerability Scanning',
    description: 'Weekly automated vulnerability scans',
    type: _ControlType.detective,
    links: _ControlLinks(risks: 2, assets: 2, assessments: 1),
    frameworks: ['ISO 27001: A.12.6.1', 'NIST: DE.CM-8', 'CIS: 7.1'],
    effectiveness: 83,
    status: _ControlStatus.implemented,
    owner: 'Security Team',
    lastAssessed: '2026-04-25',
  ),
  _ControlItem(
    id: 'CTL-009',
    name: 'Network Segmentation',
    description: 'Isolation of production and development networks',
    type: _ControlType.preventive,
    links: _ControlLinks(risks: 2, assets: 3, assessments: 1),
    frameworks: ['ISO 27001: A.13.1.3', 'NIST: PR.AC-5', 'CIS: 12.2'],
    effectiveness: 87,
    status: _ControlStatus.implemented,
    owner: 'Network Team',
    lastAssessed: '2026-04-12',
  ),
  _ControlItem(
    id: 'CTL-010',
    name: 'SIEM Monitoring',
    description: 'Real-time security event monitoring and alerting',
    type: _ControlType.detective,
    links: _ControlLinks(risks: 3, assets: 3, assessments: 1),
    frameworks: ['ISO 27001: A.12.4.1', 'NIST: DE.CM-1', 'CIS: 8.2'],
    effectiveness: 91,
    status: _ControlStatus.implemented,
    owner: 'SOC Team',
    lastAssessed: '2026-04-28',
  ),
];
