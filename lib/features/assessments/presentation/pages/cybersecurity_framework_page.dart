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
const _kPurple = Color(0xFF9810FA);
const _kOrange = Color(0xFFF54900);
const _kTeal = Color(0xFF009689);
const _kTrack = Color(0xFFE5E7EB);
const _kSubLabel = Color(0xFF6A7282);
const _kExportText = Color(0xFF0A0A0A);
const _kBorderInput = Color(0xFFD1D5DC);
const _kTabInactive = Color(0xFF4A5565);
const _kPanelBg = Color(0xFFF9FAFB);

Color _controlColor(int percent) =>
    percent >= 90 ? _kGreen : (percent >= 80 ? _kPrimary : _kAmber);

// icon badge backgrounds
const _kBgIdentify = Color(0xFFDBEAFE);
const _kBgProtect = Color(0xFFDCFCE7);
const _kBgDetect = Color(0xFFF3E8FF);
const _kBgRespond = Color(0xFFFFEDD4);
const _kBgRecover = Color(0xFFCBFBF1);

class CybersecurityFrameworkPage extends StatefulWidget {
  const CybersecurityFrameworkPage({super.key});

  @override
  State<CybersecurityFrameworkPage> createState() =>
      _CybersecurityFrameworkPageState();
}

class _CybersecurityFrameworkPageState
    extends State<CybersecurityFrameworkPage> {
  int _tab = 0;

  static const _sections = <_FunctionSection>[
    _FunctionSection(
      icon: 'cyber_identify.svg',
      iconBg: _kBgIdentify,
      title: 'Identify (ID)',
      items: [
        _SubControl(name: 'Asset Management', controls: '11/12', percent: 92),
        _SubControl(name: 'Business Environment', controls: '4/5', percent: 85),
        _SubControl(name: 'Governance', controls: '7/8', percent: 90),
        _SubControl(name: 'Risk Assessment', controls: '9/10', percent: 88),
        _SubControl(
          name: 'Risk Management Strategy',
          controls: '5/6',
          percent: 82,
        ),
      ],
      percent: 88,
      barColor: _kPrimary,
    ),
    _FunctionSection(
      icon: 'cyber_protect.svg',
      iconBg: _kBgProtect,
      title: 'Protect (PR)',
      items: [
        _SubControl(
          name: 'Identity & Access Control',
          controls: '14/15',
          percent: 93,
        ),
        _SubControl(
          name: 'Awareness & Training',
          controls: '6/8',
          percent: 75,
        ),
        _SubControl(name: 'Data Security', controls: '11/12', percent: 92),
        _SubControl(
          name: 'Protective Technology',
          controls: '12/14',
          percent: 86,
        ),
        _SubControl(name: 'Maintenance', controls: '5/6', percent: 83),
      ],
      percent: 85,
      barColor: _kGreen,
    ),
    _FunctionSection(
      icon: 'cyber_detect.svg',
      iconBg: _kBgDetect,
      title: 'Detect (DE)',
      items: [
        _SubControl(name: 'Anomalies & Events', controls: '9/10', percent: 90),
        _SubControl(
          name: 'Security Monitoring',
          controls: '12/12',
          percent: 100,
        ),
        _SubControl(
          name: 'Detection Processes',
          controls: '7/8',
          percent: 88,
        ),
      ],
      percent: 90,
      barColor: _kPurple,
    ),
    _FunctionSection(
      icon: 'cyber_respond.svg',
      iconBg: _kBgRespond,
      title: 'Respond (RS)',
      items: [
        _SubControl(name: 'Response Planning', controls: '5/6', percent: 83),
        _SubControl(name: 'Communications', controls: '5/7', percent: 71),
        _SubControl(name: 'Analysis', controls: '7/8', percent: 88),
        _SubControl(name: 'Mitigation', controls: '7/9', percent: 78),
        _SubControl(name: 'Improvements', controls: '4/5', percent: 80),
      ],
      percent: 82,
      barColor: _kOrange,
    ),
    _FunctionSection(
      icon: 'cyber_recover.svg',
      iconBg: _kBgRecover,
      title: 'Recover (RC)',
      items: [
        _SubControl(name: 'Recovery Planning', controls: '7/8', percent: 88),
        _SubControl(name: 'Improvements', controls: '4/6', percent: 67),
        _SubControl(name: 'Communications', controls: '4/5', percent: 80),
      ],
      percent: 78,
      barColor: _kTeal,
    ),
  ];

  static const _isoControls = <_IsoControl>[
    _IsoControl(
      name: 'A.5 - Information Security Policies',
      controls: '2/2',
      percent: 100,
    ),
    _IsoControl(
      name: 'A.6 - Organization of Info Security',
      controls: '6/7',
      percent: 85,
    ),
    _IsoControl(
      name: 'A.7 - Human Resource Security',
      controls: '5/6',
      percent: 92,
    ),
    _IsoControl(name: 'A.8 - Asset Management', controls: '9/10', percent: 88),
    _IsoControl(name: 'A.9 - Access Control', controls: '13/14', percent: 90),
    _IsoControl(name: 'A.10 - Cryptography', controls: '2/2', percent: 100),
    _IsoControl(
      name: 'A.11 - Physical Security',
      controls: '12/15',
      percent: 82,
    ),
    _IsoControl(
      name: 'A.12 - Operations Security',
      controls: '12/14',
      percent: 85,
    ),
    _IsoControl(
      name: 'A.13 - Communications Security',
      controls: '6/7',
      percent: 88,
    ),
    _IsoControl(
      name: 'A.14 - System Acquisition',
      controls: '10/13',
      percent: 75,
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
              for (var i = 0; i < _sections.length; i++) ...[
                _SectionCard(section: _sections[i]),
                if (i != _sections.length - 1) SizedBox(height: 16.h),
              ],
            ] else ...[
              const _IsoStatsRow(),
              SizedBox(height: 24.h),
              const _IsoControlsCard(controls: _isoControls),
            ],
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
                'Cybersecurity Framework',
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
                'NIST CSF & ISO 27001 Assessment',
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
                    l10n.exportReport,
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
              label: 'NIST Cybersecurity Framework',
              active: selected == 0,
              onTap: () => onChanged(0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _TabButton(
              label: 'ISO 27001:2013',
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
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? _kPrimary : Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : _kTabInactive,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              letterSpacing: -0.32,
            ),
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
            child: _MaturityCard(value: '85%', label: 'Overall Maturity', percent: 85),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '5',
              label: 'Functions',
              sublabel: 'Assessed',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '155',
              valueColor: _kGreen,
              label: 'Implemented Controls',
              sublabel: 'Out of 180',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: 'Tier 3',
              valueColor: _kPrimary,
              label: 'Maturity Level',
              sublabel: 'Repeatable',
            ),
          ),
        ],
      ),
    );
  }
}

class _MaturityCard extends StatelessWidget {
  const _MaturityCard({
    required this.value,
    required this.label,
    required this.percent,
  });

  final String value;
  final String label;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 29.h),
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
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
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
          _ProgressBar(percent: percent, color: _kPrimary),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.sublabel,
    this.valueColor = AppColors.textPrimary,
  });

  final String value;
  final String label;
  final String sublabel;
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
          Text(
            label,
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
            sublabel,
            style: TextStyle(
              color: _kSubLabel,
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
// Section card
// ---------------------------------------------------------------------------

class _SectionCard extends StatefulWidget {
  const _SectionCard({required this.section});

  final _FunctionSection section;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: _header(section),
              ),
            ),
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 24.h),
              decoration: const BoxDecoration(
                color: _kPanelBg,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < section.items.length; i++) ...[
                    _ControlRow(
                      name: section.items[i].name,
                      controlsLabel: '${section.items[i].controls} controls',
                      percent: section.items[i].percent,
                      background: AppColors.surface,
                      bordered: true,
                      padding: 17,
                    ),
                    if (i != section.items.length - 1) SizedBox(height: 12.h),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _header(_FunctionSection section) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: section.iconBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '$_kAssetsDir/${section.icon}',
                    width: 24.r,
                    height: 24.r,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 28 / 18,
                        letterSpacing: -0.45,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Wrap(
                        spacing: 16.w,
                        runSpacing: 4.h,
                        children: [
                          for (final item in section.items)
                            Text(
                              '${item.controls} ${item.name}',
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
                    _ProgressBar(
                      percent: section.percent,
                      color: section.barColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${section.percent}%',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
              ),
              Text(
                'Maturity',
                style: TextStyle(
                  color: _kSubLabel,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Control row (shared by NIST expanded sub-controls & ISO Annex A controls)
// ---------------------------------------------------------------------------

class _ControlRow extends StatelessWidget {
  const _ControlRow({
    required this.name,
    required this.controlsLabel,
    required this.percent,
    required this.background,
    required this.padding,
    this.bordered = false,
  });

  final String name;
  final String controlsLabel;
  final int percent;
  final Color background;
  final double padding;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.r),
        border: bordered ? Border.all(color: AppColors.border) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                controlsLabel,
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
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _ProgressBar(
                  percent: percent,
                  color: _controlColor(percent),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '$percent%',
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
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ISO 27001 tab
// ---------------------------------------------------------------------------

class _IsoStatsRow extends StatelessWidget {
  const _IsoStatsRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: _MaturityCard(
              value: '89%',
              label: 'Overall Maturity',
              percent: 89,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '10',
              label: 'Domains',
              sublabel: 'Assessed',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '77',
              valueColor: _kGreen,
              label: 'Implemented Controls',
              sublabel: 'Out of 90',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: 'Certified',
              valueColor: _kPrimary,
              label: 'Maturity Level',
              sublabel: '2024-2027',
            ),
          ),
        ],
      ),
    );
  }
}

class _IsoControlsCard extends StatelessWidget {
  const _IsoControlsCard({required this.controls});

  final List<_IsoControl> controls;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ISO 27001:2013 Annex A Controls',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < controls.length; i++) ...[
            _ControlRow(
              name: controls[i].name,
              controlsLabel: '${controls[i].controls} controls',
              percent: controls[i].percent,
              background: _kPanelBg,
              padding: 16,
            ),
            if (i != controls.length - 1) SizedBox(height: 12.h),
          ],
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

class _FunctionSection {
  const _FunctionSection({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.items,
    required this.percent,
    required this.barColor,
  });

  final String icon;
  final Color iconBg;
  final String title;
  final List<_SubControl> items;
  final int percent;
  final Color barColor;
}

class _SubControl {
  const _SubControl({
    required this.name,
    required this.controls,
    required this.percent,
  });

  final String name;
  final String controls;
  final int percent;
}

class _IsoControl {
  const _IsoControl({
    required this.name,
    required this.controls,
    required this.percent,
  });

  final String name;
  final String controls;
  final int percent;
}
