import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';

const _kAssetsDir = 'assets/figma/assessments/svg';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kPrimary = Color(0xFF155DFC);
const _kGreen = Color(0xFF00A63E);
const _kAmber = Color(0xFFD08700);
const _kTrack = Color(0xFFE5E7EB);
const _kSubLabel = Color(0xFF6A7282);
const _kExportText = Color(0xFF0A0A0A);
const _kBorderInput = Color(0xFFD1D5DC);

// KRI — green
const _kKriGreenBg = Color(0xFFF0FDF4);
const _kKriGreenBorder = Color(0xFFB9F8CF);
const _kKriGreenValue = Color(0xFF008236);
const _kKriGreenTrend = Color(0xFF00A63E);

// KRI — amber
const _kKriAmberBg = Color(0xFFFEFCE8);
const _kKriAmberBorder = Color(0xFFFFF085);
const _kKriAmberValue = Color(0xFFA65F00);
const _kKriAmberTrend = Color(0xFFD08700);

// KRI — blue
const _kKriBlueBg = Color(0xFFEFF6FF);
const _kKriBlueBorder = Color(0xFFBEDBFF);
const _kKriBlueValue = Color(0xFF1447E6);
const _kKriBlueTrend = Color(0xFF155DFC);

// action items — amber
const _kActionBg = Color(0xFFFEFCE8);
const _kActionBorder = Color(0xFFFFF085);
const _kActionTitle = Color(0xFF733E0A);
const _kActionBody = Color(0xFFA65F00);
const _kActionMeta = Color(0xFFD08700);

class OrmFrameworkPage extends StatelessWidget {
  const OrmFrameworkPage({super.key});

  static const _categories = <_RiskCategory>[
    _RiskCategory(
      title: 'People Risk',
      description: 'Risks from human error, fraud, or inadequate staffing',
      percent: 72,
      barColor: _kPrimary,
      details: [
        _RiskDetail(
          title: 'Key person dependency',
          likelihood: 'Medium',
          impact: 'High',
          mitigation: 'Succession planning implemented',
          status: _RiskStatus.info,
        ),
        _RiskDetail(
          title: 'Insider threat',
          likelihood: 'Low',
          impact: 'Critical',
          mitigation: 'Background checks and monitoring',
          status: _RiskStatus.ok,
        ),
        _RiskDetail(
          title: 'Skills gap',
          likelihood: 'High',
          impact: 'Medium',
          mitigation: 'Training program in development',
          status: _RiskStatus.warn,
        ),
        _RiskDetail(
          title: 'Employee fraud',
          likelihood: 'Low',
          impact: 'High',
          mitigation: 'Segregation of duties',
          status: _RiskStatus.ok,
        ),
      ],
    ),
    _RiskCategory(
      title: 'Process Risk',
      description: 'Risks from inadequate or failed internal processes',
      percent: 78,
      barColor: _kPrimary,
      details: [
        _RiskDetail(
          title: 'Transaction processing errors',
          likelihood: 'Medium',
          impact: 'High',
          mitigation: 'Automated controls and reconciliation',
          status: _RiskStatus.ok,
        ),
        _RiskDetail(
          title: 'Compliance failures',
          likelihood: 'Low',
          impact: 'Critical',
          mitigation: 'Regular audits and monitoring',
          status: _RiskStatus.ok,
        ),
        _RiskDetail(
          title: 'Inadequate documentation',
          likelihood: 'Medium',
          impact: 'Medium',
          mitigation: 'Process documentation initiative',
          status: _RiskStatus.warn,
        ),
        _RiskDetail(
          title: 'Manual process dependency',
          likelihood: 'High',
          impact: 'High',
          mitigation: 'Process automation roadmap',
          status: _RiskStatus.info,
        ),
      ],
    ),
    _RiskCategory(
      title: 'Systems & Technology Risk',
      description: 'Risks from system failures, outages, or technology issues',
      percent: 68,
      barColor: _kAmber,
      details: [
        _RiskDetail(
          title: 'System outages',
          likelihood: 'Medium',
          impact: 'Critical',
          mitigation: 'Redundancy and failover systems',
          status: _RiskStatus.warn,
        ),
        _RiskDetail(
          title: 'Cybersecurity breaches',
          likelihood: 'Medium',
          impact: 'Critical',
          mitigation: 'Security controls and monitoring',
          status: _RiskStatus.info,
        ),
        _RiskDetail(
          title: 'Legacy system failures',
          likelihood: 'High',
          impact: 'High',
          mitigation: 'Modernization program underway',
          status: _RiskStatus.warn,
        ),
        _RiskDetail(
          title: 'Data integrity issues',
          likelihood: 'Low',
          impact: 'High',
          mitigation: 'Backup and validation controls',
          status: _RiskStatus.ok,
        ),
      ],
    ),
    _RiskCategory(
      title: 'External Events Risk',
      description: 'Risks from external events beyond organizational control',
      percent: 75,
      barColor: _kPrimary,
      details: [
        _RiskDetail(
          title: 'Natural disasters',
          likelihood: 'Low',
          impact: 'Critical',
          mitigation: 'Business continuity planning',
          status: _RiskStatus.ok,
        ),
        _RiskDetail(
          title: 'Regulatory changes',
          likelihood: 'Medium',
          impact: 'High',
          mitigation: 'Regulatory monitoring program',
          status: _RiskStatus.ok,
        ),
        _RiskDetail(
          title: 'Vendor disruptions',
          likelihood: 'Medium',
          impact: 'Medium',
          mitigation: 'Vendor diversification strategy',
          status: _RiskStatus.warn,
        ),
        _RiskDetail(
          title: 'Market volatility',
          likelihood: 'Medium',
          impact: 'High',
          mitigation: 'Hedging and risk transfer',
          status: _RiskStatus.info,
        ),
      ],
    ),
  ];

  static const _kris = <_Kri>[
    _Kri(
      label: 'System Uptime',
      value: '99.97%',
      trend: '↑ 0.02% from last month',
      bg: _kKriGreenBg,
      border: _kKriGreenBorder,
      valueColor: _kKriGreenValue,
      trendColor: _kKriGreenTrend,
    ),
    _Kri(
      label: 'Process Errors',
      value: '24',
      trend: '↓ 6 from last month',
      bg: _kKriAmberBg,
      border: _kKriAmberBorder,
      valueColor: _kKriAmberValue,
      trendColor: _kKriAmberTrend,
    ),
    _Kri(
      label: 'Staff Turnover',
      value: '8.2%',
      trend: '↓ 1.3% from last quarter',
      bg: _kKriBlueBg,
      border: _kKriBlueBorder,
      valueColor: _kKriBlueValue,
      trendColor: _kKriBlueTrend,
    ),
    _Kri(
      label: 'Vendor SLA Compliance',
      value: '96%',
      trend: '↑ 2% from last month',
      bg: _kKriGreenBg,
      border: _kKriGreenBorder,
      valueColor: _kKriGreenValue,
      trendColor: _kKriGreenTrend,
    ),
  ];

  static const _actions = <_ActionData>[
    _ActionData(
      title: 'Address Skills Gap',
      description:
          'Accelerate training program rollout for critical technical skills',
      meta: 'Due: 2026-06-30 • Owner: HR Director',
    ),
    _ActionData(
      title: 'Legacy System Modernization',
      description:
          'Complete migration from legacy systems to reduce operational risk',
      meta: 'Due: 2026-09-30 • Owner: CTO',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(l10n: l10n),
            SizedBox(height: 24.h),
            const _StatsRow(),
            SizedBox(height: 24.h),
            const _RiskCategoriesGrid(categories: _categories),
            SizedBox(height: 24.h),
            const _KrisCard(kris: _kris),
            SizedBox(height: 24.h),
            const _PriorityActionsCard(actions: _actions),
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
  const _TitleBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () => context.deferGo(AppRoutes.assessments),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                border: Border.all(color: _kBorderInput),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '$_kAssetsDir/back_arrow.svg',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operational Risk Management (ORM)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'People, Process, Systems, and External Events',
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
              decoration: BoxDecoration(
                border: Border.all(color: _kBorderInput),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '$_kAssetsDir/export.svg',
                    width: 16.r,
                    height: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Export Report',
                    style: TextStyle(
                      color: _kExportText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: _StatCard(
              value: '73%',
              label: 'Avg Risk Mitigation',
              progressPercent: 73,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '16',
              label: 'Identified Risks',
              sublabel: 'Across 4 categories',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '5',
              valueColor: _kGreen,
              label: 'Strong Mitigations',
              sublabel: 'Effective controls',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '2',
              valueColor: _kAmber,
              label: 'Developing Controls',
              sublabel: 'Needs attention',
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
    this.sublabel,
    this.progressPercent,
    this.valueColor = AppColors.textPrimary,
  });

  final String value;
  final String label;
  final String? sublabel;
  final int? progressPercent;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
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
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: progressPercent != null ? 8.h : 0),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textBody,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
          if (progressPercent != null)
            _ProgressBar(percent: progressPercent!, color: _kPrimary),
          if (sublabel != null) ...[
            SizedBox(height: 4.h),
            Text(
              sublabel!,
              style: TextStyle(
                color: _kSubLabel,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risk categories grid (2x2)
// ---------------------------------------------------------------------------

class _RiskCategoriesGrid extends StatelessWidget {
  const _RiskCategoriesGrid({required this.categories});

  final List<_RiskCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _RiskCard(data: categories[0])),
              SizedBox(width: 24.w),
              Expanded(child: _RiskCard(data: categories[1])),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _RiskCard(data: categories[2])),
              SizedBox(width: 24.w),
              Expanded(child: _RiskCard(data: categories[3])),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskCard extends StatefulWidget {
  const _RiskCard({required this.data});

  final _RiskCategory data;

  @override
  State<_RiskCard> createState() => _RiskCardState();
}

class _RiskCardState extends State<_RiskCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 26.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 28 / 18,
                          letterSpacing: -0.45,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        data.description,
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          letterSpacing: -0.154,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.percent}%',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      height: 32 / 24,
                      letterSpacing: 0.072,
                    ),
                  ),
                  Text(
                    'Mitigation',
                    style: TextStyle(
                      color: _kSubLabel,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _ProgressBar(percent: data.percent, color: data.barColor),
          SizedBox(height: 16.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.75.h),
                child: Center(
                  child: Text(
                    _expanded ? 'Hide Details' : 'View Details →',
                    style: TextStyle(
                      color: _kPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      letterSpacing: -0.154,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_expanded) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.only(top: 18.h),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < data.details.length; i++) ...[
                    _RiskDetailCard(data: data.details[i]),
                    if (i != data.details.length - 1) SizedBox(height: 12.h),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RiskDetailCard extends StatelessWidget {
  const _RiskDetailCard({required this.data});

  final _RiskDetail data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset(
                data.status.asset,
                width: 20.r,
                height: 20.r,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _metaText('Likelihood: ', data.likelihood),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _metaText('Impact: ', data.impact),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Mitigation: ',
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                  ),
                ),
                TextSpan(
                  text: data.mitigation,
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaText(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: _kSubLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: const Color(0xFF364153),
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

// ---------------------------------------------------------------------------
// Key Risk Indicators
// ---------------------------------------------------------------------------

class _KrisCard extends StatelessWidget {
  const _KrisCard({required this.kris});

  final List<_Kri> kris;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Key Risk Indicators (KRIs)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < kris.length; i++) ...[
                  Expanded(child: _KriCard(data: kris[i])),
                  if (i != kris.length - 1) SizedBox(width: 16.w),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KriCard extends StatelessWidget {
  const _KriCard({required this.data});

  final _Kri data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: data.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            data.value,
            style: TextStyle(
              color: data.valueColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            data.trend,
            style: TextStyle(
              color: data.trendColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Priority action items
// ---------------------------------------------------------------------------

class _PriorityActionsCard extends StatelessWidget {
  const _PriorityActionsCard({required this.actions});

  final List<_ActionData> actions;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Priority Action Items',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < actions.length; i++) ...[
            _ActionItem(data: actions[i]),
            if (i != actions.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.data});

  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: _kActionBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _kActionBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SvgPicture.asset(
              '$_kAssetsDir/orm_warning.svg',
              width: 20.r,
              height: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: _kActionTitle,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.description,
                  style: TextStyle(
                    color: _kActionBody,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.meta,
                  style: TextStyle(
                    color: _kActionMeta,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Progress bar
// ---------------------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.percent, required this.color});

  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        width: double.infinity,
        height: 8.h,
        color: _kTrack,
        child: FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: (percent / 100).clamp(0.0, 1.0),
          child: Container(color: color),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _RiskCategory {
  const _RiskCategory({
    required this.title,
    required this.description,
    required this.percent,
    required this.barColor,
    required this.details,
  });

  final String title;
  final String description;
  final int percent;
  final Color barColor;
  final List<_RiskDetail> details;
}

enum _RiskStatus {
  ok('$_kAssetsDir/orm_status_ok.svg'),
  warn('$_kAssetsDir/orm_status_warn.svg'),
  info('$_kAssetsDir/orm_status_info.svg');

  const _RiskStatus(this.asset);

  final String asset;
}

class _RiskDetail {
  const _RiskDetail({
    required this.title,
    required this.likelihood,
    required this.impact,
    required this.mitigation,
    required this.status,
  });

  final String title;
  final String likelihood;
  final String impact;
  final String mitigation;
  final _RiskStatus status;
}

class _Kri {
  const _Kri({
    required this.label,
    required this.value,
    required this.trend,
    required this.bg,
    required this.border,
    required this.valueColor,
    required this.trendColor,
  });

  final String label;
  final String value;
  final String trend;
  final Color bg;
  final Color border;
  final Color valueColor;
  final Color trendColor;
}

class _ActionData {
  const _ActionData({
    required this.title,
    required this.description,
    required this.meta,
  });

  final String title;
  final String description;
  final String meta;
}
