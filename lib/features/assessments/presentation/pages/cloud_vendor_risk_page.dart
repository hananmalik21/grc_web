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
const _kTrack = Color(0xFFE5E7EB);
const _kSubLabel = Color(0xFF6A7282);
const _kExportText = Color(0xFF0A0A0A);
const _kBorderInput = Color(0xFFD1D5DC);
const _kTabInactive = Color(0xFF4A5565);
const _kPanelBg = Color(0xFFF9FAFB);
const _kControlName = Color(0xFF364153);

// finding — critical (red)
const _kCritBg = Color(0xFFFEF2F2);
const _kCritBorder = Color(0xFFFFC9C9);
const _kCritTitle = Color(0xFF82181A);
const _kCritBody = Color(0xFFC10007);
const _kCritMeta = Color(0xFFE7000B);

// finding — warning (amber)
const _kWarnBg = Color(0xFFFEFCE8);
const _kWarnBorder = Color(0xFFFFF085);
const _kWarnTitle = Color(0xFF733E0A);
const _kWarnBody = Color(0xFFA65F00);
const _kWarnMeta = Color(0xFFD08700);

Color _scoreColor(int score) => score >= 85 ? _kGreen : _kPrimary;

class CloudVendorRiskPage extends StatefulWidget {
  const CloudVendorRiskPage({super.key});

  @override
  State<CloudVendorRiskPage> createState() => _CloudVendorRiskPageState();
}

class _CloudVendorRiskPageState extends State<CloudVendorRiskPage> {
  int _tab = 0;

  static const _providers = <_Provider>[
    _Provider(
      name: 'Amazon Web Services',
      assets: '45 assets',
      score: 85,
      compliance: 92,
      controls: '4/5',
      controlList: [
        _Control(name: 'IAM Configuration', percent: 95),
        _Control(name: 'Network Segmentation', percent: 90),
        _Control(name: 'Encryption at Rest', percent: 100),
        _Control(name: 'Logging & Monitoring', percent: 80),
        _Control(name: 'Backup & DR', percent: 88),
      ],
    ),
    _Provider(
      name: 'Microsoft Azure',
      assets: '28 assets',
      score: 82,
      compliance: 88,
      controls: '4/5',
      controlList: [
        _Control(name: 'IAM Configuration', percent: 88),
        _Control(name: 'Network Segmentation', percent: 85),
        _Control(name: 'Encryption at Rest', percent: 95),
        _Control(name: 'Logging & Monitoring', percent: 78),
        _Control(name: 'Backup & DR', percent: 80),
      ],
    ),
    _Provider(
      name: 'Google Cloud Platform',
      assets: '15 assets',
      score: 78,
      compliance: 85,
      controls: '3/5',
      controlList: [
        _Control(name: 'IAM Configuration', percent: 82),
        _Control(name: 'Network Segmentation', percent: 75),
        _Control(name: 'Encryption at Rest', percent: 90),
        _Control(name: 'Logging & Monitoring', percent: 70),
        _Control(name: 'Backup & DR', percent: 75),
      ],
    ),
    _Provider(
      name: 'Oracle Cloud Infrastructure',
      assets: '12 assets',
      score: 88,
      compliance: 90,
      controls: '5/5',
      controlList: [
        _Control(name: 'IAM Configuration', percent: 92),
        _Control(name: 'Network Segmentation', percent: 88),
        _Control(name: 'Encryption at Rest', percent: 95),
        _Control(name: 'Logging & Monitoring', percent: 85),
        _Control(name: 'Backup & DR', percent: 90),
      ],
    ),
  ];

  static const _findings = <_Finding>[
    _Finding(
      title: 'S3 Bucket Public Access - AWS',
      description: '3 S3 buckets found with public read access enabled',
      meta: 'Critical • Discovered: 2026-04-28',
      severity: _Severity.critical,
    ),
    _Finding(
      title: 'MFA Not Enforced - Azure',
      description: '8 privileged accounts without MFA enabled',
      meta: 'High • Discovered: 2026-04-25',
      severity: _Severity.high,
    ),
    _Finding(
      title: 'Logging Disabled - GCP',
      description: 'Cloud audit logs not enabled for 2 projects',
      meta: 'Medium • Discovered: 2026-04-22',
      severity: _Severity.medium,
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
            _TabSwitcher(
              selected: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            SizedBox(height: 24.h),
            if (_tab == 0) ...[
              const _StatsRow(),
              SizedBox(height: 24.h),
              const _ProvidersGrid(providers: _providers),
              SizedBox(height: 24.h),
              const _RecentFindingsCard(findings: _findings),
            ] else
              const _VendorPlaceholder(),
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
                'Cloud & Vendor Risk Management',
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
                'Multi-cloud security and third-party risk assessment',
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
// Tab switcher
// ---------------------------------------------------------------------------

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              icon: 'cloud_tab.svg',
              label: 'Cloud Security Posture',
              active: selected == 0,
              onTap: () => onChanged(0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _TabButton(
              icon: 'vendor_tab.svg',
              label: 'Vendor Assessment',
              active: selected == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : _kTabInactive;
    return Material(
      color: active ? _kPrimary : Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '$_kAssetsDir/$icon',
                width: 16.r,
                height: 16.r,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              value: '83%',
              label: 'Avg Cloud Security Score',
              progressPercent: 83,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '4',
              label: 'Cloud Providers',
              sublabel: 'Active environments',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '100',
              label: 'Cloud Assets',
              sublabel: 'Across all providers',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '12',
              valueColor: _kGreen,
              label: 'Critical Findings',
              sublabel: 'Resolved this month',
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
// Providers grid (2x2)
// ---------------------------------------------------------------------------

class _ProvidersGrid extends StatelessWidget {
  const _ProvidersGrid({required this.providers});

  final List<_Provider> providers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ProviderCard(data: providers[0])),
              SizedBox(width: 24.w),
              Expanded(child: _ProviderCard(data: providers[1])),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ProviderCard(data: providers[2])),
              SizedBox(width: 24.w),
              Expanded(child: _ProviderCard(data: providers[3])),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatefulWidget {
  const _ProviderCard({required this.data});

  final _Provider data;

  @override
  State<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<_ProviderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(data),
          SizedBox(height: 16.h),
          _ProgressBar(percent: data.score, color: _scoreColor(data.score)),
          SizedBox(height: 16.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 2.75.h,
                  bottom: _expanded ? 0 : 16.h,
                ),
                child: Center(
                  child: Text(
                    _expanded ? 'Hide Details' : 'View Security Controls →',
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
              padding: EdgeInsets.only(top: 17.h),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < data.controlList.length; i++) ...[
                    _ControlChip(data: data.controlList[i]),
                    if (i != data.controlList.length - 1) SizedBox(height: 8.h),
                  ],
                ],
              ),
            ),
          ],
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.only(top: 17.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _footerStat('Compliance', '${data.compliance}%'),
                ),
                SizedBox(width: 16.w),
                Expanded(child: _footerStat('Controls', data.controls)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(_Provider data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('☁️', style: TextStyle(fontSize: 30.sp, height: 36 / 30)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 28 / 18,
                        letterSpacing: -0.45,
                      ),
                    ),
                    Text(
                      data.assets,
                      style: TextStyle(
                        color: _kSubLabel,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: -0.154,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${data.score}%',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                height: 32 / 24,
                letterSpacing: 0.072,
              ),
            ),
            Text(
              'Security Score',
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
    );
  }

  Widget _footerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _kSubLabel,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

class _ControlChip extends StatelessWidget {
  const _ControlChip({required this.data});

  final _Control data;

  @override
  Widget build(BuildContext context) {
    final ok = data.percent >= 85;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _kPanelBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            ok
                ? '$_kAssetsDir/orm_status_ok.svg'
                : '$_kAssetsDir/orm_status_warn.svg',
            width: 16.r,
            height: 16.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              data.name,
              style: TextStyle(
                color: _kControlName,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${data.percent}%',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent findings
// ---------------------------------------------------------------------------

class _RecentFindingsCard extends StatelessWidget {
  const _RecentFindingsCard({required this.findings});

  final List<_Finding> findings;

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
            'Recent Findings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < findings.length; i++) ...[
            _FindingItem(data: findings[i]),
            if (i != findings.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _FindingItem extends StatelessWidget {
  const _FindingItem({required this.data});

  final _Finding data;

  @override
  Widget build(BuildContext context) {
    final isCritical = data.severity == _Severity.critical;
    final bg = isCritical ? _kCritBg : _kWarnBg;
    final border = isCritical ? _kCritBorder : _kWarnBorder;
    final titleColor = isCritical ? _kCritTitle : _kWarnTitle;
    final bodyColor = isCritical ? _kCritBody : _kWarnBody;
    final metaColor = isCritical ? _kCritMeta : _kWarnMeta;
    final icon = switch (data.severity) {
      _Severity.critical => 'finding_critical.svg',
      _Severity.high => 'finding_high.svg',
      _Severity.medium => 'finding_medium.svg',
    };

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SvgPicture.asset(
              '$_kAssetsDir/$icon',
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
                    color: titleColor,
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
                    color: bodyColor,
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
                    color: metaColor,
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
// Vendor placeholder (tab 2 — design not provided)
// ---------------------------------------------------------------------------

class _VendorPlaceholder extends StatelessWidget {
  const _VendorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          'Vendor Assessment',
          style: TextStyle(
            color: _kSubLabel,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
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

class _Provider {
  const _Provider({
    required this.name,
    required this.assets,
    required this.score,
    required this.compliance,
    required this.controls,
    required this.controlList,
  });

  final String name;
  final String assets;
  final int score;
  final int compliance;
  final String controls;
  final List<_Control> controlList;
}

class _Control {
  const _Control({required this.name, required this.percent});

  final String name;
  final int percent;
}

enum _Severity { critical, high, medium }

class _Finding {
  const _Finding({
    required this.title,
    required this.description,
    required this.meta,
    required this.severity,
  });

  final String title;
  final String description;
  final String meta;
  final _Severity severity;
}
