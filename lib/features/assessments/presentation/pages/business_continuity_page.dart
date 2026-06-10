import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

const _kHeaderBg = Color(0xFFF9FAFB);
const _kRowBorder = Color(0xFFF3F4F6);
const _kHeaderText = Color(0xFF364153);
const _kCellMuted = Color(0xFF364153);

// expandable compliance questions
const _kNumberBadgeBg = Color(0xFFDBEAFE);
const _kNumberBadgeFg = Color(0xFF155DFC);
const _kRadioSelected = Color(0xFF0075FF);
const _kRadioBorder = Color(0xFF767676);
const _kEvidenceBg = Color(0xFFEFF6FF);
const _kEvidenceBorder = Color(0xFFBEDBFF);

// status pills
const _kTestedBg = Color(0xFFDCFCE7);
const _kTestedText = Color(0xFF016630);
const _kTestDueBg = Color(0xFFFEF9C2);
const _kTestDueText = Color(0xFF894B00);

// compliance summary boxes
const _kBoxGreenBg = Color(0xFFF0FDF4);
const _kBoxGreenVal = Color(0xFF008236);
const _kBoxAmberBg = Color(0xFFFEFCE8);
const _kBoxAmberVal = Color(0xFFA65F00);
const _kBoxRedBg = Color(0xFFFEF2F2);
const _kBoxRedVal = Color(0xFFC10007);
const _kBoxBlueBg = Color(0xFFEFF6FF);
const _kBoxBlueVal = Color(0xFF1447E6);

// upcoming — blue
const _kUpBlueBg = Color(0xFFEFF6FF);
const _kUpBlueBorder = Color(0xFFBEDBFF);
const _kUpBlueTitle = Color(0xFF1C398E);
const _kUpBlueBody = Color(0xFF1447E6);
const _kUpBlueMeta = Color(0xFF155DFC);

// upcoming — amber
const _kUpAmberBg = Color(0xFFFEFCE8);
const _kUpAmberBorder = Color(0xFFFFF085);
const _kUpAmberTitle = Color(0xFF733E0A);
const _kUpAmberBody = Color(0xFFA65F00);
const _kUpAmberMeta = Color(0xFFD08700);

// upcoming — green
const _kUpGreenBg = Color(0xFFF0FDF4);
const _kUpGreenBorder = Color(0xFFB9F8CF);
const _kUpGreenTitle = Color(0xFF0D542B);
const _kUpGreenBody = Color(0xFF008236);
const _kUpGreenMeta = Color(0xFF00A63E);

// Table column flex factors (mirroring Figma cell widths).
const _flexProcess = 25;
const _flexRto = 11;
const _flexRpo = 13;
const _flexMtd = 14;
const _flexDeps = 18;
const _flexLastTest = 17;
const _flexReadiness = 17;
const _flexStatus = 15;

class BusinessContinuityPage extends StatelessWidget {
  const BusinessContinuityPage({super.key});

  static const _processes = <_Process>[
    _Process(
      name: 'Payment Processing',
      rto: '4',
      rpo: '1',
      mtd: '8',
      dependencies: '3 systems',
      lastTest: '2026-03-15',
      readiness: 95,
      readinessColor: _kGreen,
      status: _ProcessStatus.tested,
    ),
    _Process(
      name: 'Customer Portal',
      rto: '8',
      rpo: '4',
      mtd: '24',
      dependencies: '3 systems',
      lastTest: '2026-04-10',
      readiness: 92,
      readinessColor: _kGreen,
      status: _ProcessStatus.tested,
    ),
    _Process(
      name: 'Order Management',
      rto: '6',
      rpo: '2',
      mtd: '12',
      dependencies: '3 systems',
      lastTest: '2025-12-20',
      readiness: 78,
      readinessColor: _kAmber,
      status: _ProcessStatus.testDue,
    ),
    _Process(
      name: 'Data Analytics',
      rto: '24',
      rpo: '12',
      mtd: '72',
      dependencies: '2 systems',
      lastTest: '2026-02-28',
      readiness: 88,
      readinessColor: _kPrimary,
      status: _ProcessStatus.tested,
    ),
  ];

  static const _requirements = <_Requirement>[
    _Requirement(
      name: 'Business Impact Analysis',
      percent: 75,
      color: _kPrimary,
      questions: [
        _ComplianceQuestion(
          text: 'Are critical business processes identified and documented?',
          answer: _RequirementAnswer.yes,
          evidence: 'BIA documentation v3.2',
        ),
        _ComplianceQuestion(
          text: 'Are RTO/RPO objectives defined for each critical process?',
          answer: _RequirementAnswer.yes,
          evidence: 'Recovery objectives matrix',
        ),
        _ComplianceQuestion(
          text: 'Are financial impacts quantified for downtime scenarios?',
          answer: _RequirementAnswer.yes,
          evidence: 'Financial impact analysis',
        ),
        _ComplianceQuestion(
          text: 'Are upstream and downstream dependencies mapped?',
          answer: _RequirementAnswer.partial,
          evidence: 'Dependency mapping in progress',
        ),
      ],
    ),
    _Requirement(
      name: 'Recovery Planning',
      percent: 75,
      color: _kPrimary,
      questions: [
        _ComplianceQuestion(
          text:
              'Are business continuity plans documented for all critical processes?',
          answer: _RequirementAnswer.yes,
          evidence: 'BCP playbooks library',
        ),
        _ComplianceQuestion(
          text: 'Are disaster recovery procedures tested quarterly?',
          answer: _RequirementAnswer.partial,
          evidence: 'Last test: 6 months ago',
        ),
        _ComplianceQuestion(
          text: 'Are alternate site/facilities identified and available?',
          answer: _RequirementAnswer.yes,
          evidence: 'DR site contract',
        ),
        _ComplianceQuestion(
          text: 'Are recovery teams assigned with clear roles?',
          answer: _RequirementAnswer.yes,
          evidence: 'Recovery team roster',
        ),
      ],
    ),
    _Requirement(
      name: 'Testing & Exercises',
      percent: 50,
      color: _kAmber,
      questions: [
        _ComplianceQuestion(
          text: 'Are tabletop exercises conducted at least annually?',
          answer: _RequirementAnswer.yes,
          evidence: 'Exercise schedule 2026',
        ),
        _ComplianceQuestion(
          text: 'Are full DR tests performed for critical systems?',
          answer: _RequirementAnswer.partial,
          evidence: 'Partial coverage achieved',
        ),
        _ComplianceQuestion(
          text: 'Are test results documented with lessons learned?',
          answer: _RequirementAnswer.yes,
          evidence: 'Test reports archive',
        ),
        _ComplianceQuestion(
          text: 'Are identified gaps remediated within SLA?',
          answer: _RequirementAnswer.no,
          evidence: 'Backlog of 8 open items',
        ),
      ],
    ),
    _Requirement(
      name: 'Crisis Management',
      percent: 75,
      color: _kPrimary,
      questions: [
        _ComplianceQuestion(
          text: 'Is there an incident command structure defined?',
          answer: _RequirementAnswer.yes,
          evidence: 'ICS documentation',
        ),
        _ComplianceQuestion(
          text: 'Are communication protocols established?',
          answer: _RequirementAnswer.yes,
          evidence: 'Crisis comm plan',
        ),
        _ComplianceQuestion(
          text: 'Are stakeholder notification procedures documented?',
          answer: _RequirementAnswer.yes,
          evidence: 'Notification matrix',
        ),
        _ComplianceQuestion(
          text: 'Is there a crisis management war room?',
          answer: _RequirementAnswer.partial,
          evidence: 'Virtual setup only',
        ),
      ],
    ),
  ];

  static const _upcoming = <_Upcoming>[
    _Upcoming(
      title: 'Tabletop Exercise - Ransomware Scenario',
      description: 'Quarterly BCM tabletop with executive team',
      meta: 'Scheduled: 2026-05-15 • Duration: 4 hours',
      tone: _UpcomingTone.blue,
    ),
    _Upcoming(
      title: 'DR Test - Order Management System',
      description: 'Full failover test to DR site (overdue)',
      meta: 'Due: 2026-05-01 • Duration: 8 hours',
      tone: _UpcomingTone.amber,
    ),
    _Upcoming(
      title: 'Communication Test - Crisis Notification',
      description: 'Test emergency notification system',
      meta: 'Scheduled: 2026-05-20 • Duration: 2 hours',
      tone: _UpcomingTone.green,
    ),
  ];

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
            const _CriticalProcessesCard(processes: _processes),
            SizedBox(height: 24.h),
            const _ComplianceCard(requirements: _requirements),
            SizedBox(height: 24.h),
            const _UpcomingCard(items: _upcoming),
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
    return Row(
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
                'Business Continuity & Resilience',
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
                'ISO 22301 - Business Continuity Management System',
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
              value: '87%',
              delta: '+3%',
              deltaColor: _kGreen,
              label: 'Overall Resilience Score',
              percent: 87,
              barColor: _kGreen,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '92%',
              delta: '+5%',
              deltaColor: _kGreen,
              label: 'Avg RTO Achievement',
              percent: 92,
              barColor: _kGreen,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '78%',
              delta: '-2%',
              deltaColor: _kAmber,
              label: 'Test Success Rate',
              percent: 78,
              barColor: _kAmber,
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '85%',
              delta: '+4%',
              deltaColor: _kPrimary,
              label: 'Recovery Readiness',
              percent: 85,
              barColor: _kPrimary,
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
    required this.delta,
    required this.deltaColor,
    required this.label,
    required this.percent,
    required this.barColor,
  });

  final String value;
  final String delta;
  final Color deltaColor;
  final String label;
  final int percent;
  final Color barColor;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                delta,
                style: TextStyle(
                  color: deltaColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
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
          SizedBox(height: 8.h),
          _ProgressBar(percent: percent, color: barColor, height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Critical Business Processes table
// ---------------------------------------------------------------------------

class _CriticalProcessesCard extends StatelessWidget {
  const _CriticalProcessesCard({required this.processes});

  final List<_Process> processes;

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
            'Critical Business Processes',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          _headerRow(),
          for (final p in processes) _bodyRow(p),
        ],
      ),
    );
  }

  Widget _headerRow() {
    Widget cell(String text, int flex) => Expanded(
          flex: flex,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              text,
              style: TextStyle(
                color: _kHeaderText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: -0.154,
              ),
            ),
          ),
        );
    return Container(
      decoration: const BoxDecoration(
        color: _kHeaderBg,
        border: Border(bottom: BorderSide(color: _kTrack)),
      ),
      child: Row(
        children: [
          cell('Process', _flexProcess),
          cell('RTO (hrs)', _flexRto),
          cell('RPO (hrs)', _flexRpo),
          cell('MTD (hrs)', _flexMtd),
          cell('Dependencies', _flexDeps),
          cell('Last Test', _flexLastTest),
          cell('Readiness', _flexReadiness),
          cell('Status', _flexStatus),
        ],
      ),
    );
  }

  Widget _bodyRow(_Process p) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kRowBorder)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _cell(
              _flexProcess,
              Text(
                p.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ),
            _cell(_flexRto, _iconValue('bcm_clock_sm.svg', p.rto)),
            _cell(_flexRpo, _iconValue('bcm_clock_sm.svg', p.rpo)),
            _cell(_flexMtd, _iconValue('bcm_warn_sm.svg', p.mtd)),
            _cell(
              _flexDeps,
              Text(
                p.dependencies,
                style: TextStyle(
                  color: _kCellMuted,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
            ),
            _cell(
              _flexLastTest,
              Text(
                p.lastTest,
                style: TextStyle(
                  color: _kCellMuted,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ),
            _cell(_flexReadiness, _readiness(p)),
            _cell(_flexStatus, _statusPill(p.status)),
          ],
        ),
      ),
    );
  }

  Widget _cell(int flex, Widget child) => Expanded(
        flex: flex,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Align(alignment: Alignment.centerLeft, child: child),
        ),
      );

  Widget _iconValue(String icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 12.w,
          height: 12.h,
          child: SvgPicture.asset(
            '$_kAssetsDir/$icon',
            width: 12.w,
            height: 12.h,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            color: _kCellMuted,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }

  Widget _readiness(_Process p) {
    return Row(
      children: [
        Expanded(
          child: _ProgressBar(
            percent: p.readiness,
            color: p.readinessColor,
            height: 6,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '${p.readiness}%',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(_ProcessStatus status) {
    final (bg, fg, label) = switch (status) {
      _ProcessStatus.tested => (_kTestedBg, _kTestedText, 'Tested'),
      _ProcessStatus.testDue => (_kTestDueBg, _kTestDueText, 'Test Due'),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100.r),
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
}

// ---------------------------------------------------------------------------
// ISO 22301 Compliance Assessment
// ---------------------------------------------------------------------------

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.requirements});

  final List<_Requirement> requirements;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ISO 22301 Compliance Assessment',
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
                      'Business Continuity Management requirements',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '69%',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      height: 36 / 30,
                      letterSpacing: 0.42,
                    ),
                  ),
                  Text(
                    'Compliance Score',
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
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  child: _SummaryBox(
                    label: 'Compliant',
                    value: '11',
                    bg: _kBoxGreenBg,
                    valueColor: _kBoxGreenVal,
                  ),
                ),
                SizedBox(width: 16.w),
                const Expanded(
                  child: _SummaryBox(
                    label: 'Partial',
                    value: '4',
                    bg: _kBoxAmberBg,
                    valueColor: _kBoxAmberVal,
                  ),
                ),
                SizedBox(width: 16.w),
                const Expanded(
                  child: _SummaryBox(
                    label: 'Non-Compliant',
                    value: '1',
                    bg: _kBoxRedBg,
                    valueColor: _kBoxRedVal,
                  ),
                ),
                SizedBox(width: 16.w),
                const Expanded(
                  child: _SummaryBox(
                    label: 'Total',
                    value: '16',
                    bg: _kBoxBlueBg,
                    valueColor: _kBoxBlueVal,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < requirements.length; i++) ...[
            _RequirementSection(data: requirements[i]),
            if (i != requirements.length - 1) SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({
    required this.label,
    required this.value,
    required this.bg,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color bg;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 20,
              letterSpacing: -0.46,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementSection extends StatefulWidget {
  const _RequirementSection({required this.data});

  final _Requirement data;

  @override
  State<_RequirementSection> createState() => _RequirementSectionState();
}

class _RequirementSectionState extends State<_RequirementSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: _kHeaderBg,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
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
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 96.w,
                      child: _ProgressBar(
                        percent: data.percent,
                        color: data.color,
                        height: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < data.questions.length; i++) ...[
                    _ComplianceQuestionCard(
                      index: i + 1,
                      question: data.questions[i],
                    ),
                    if (i != data.questions.length - 1) SizedBox(height: 12.h),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ComplianceQuestionCard extends StatelessWidget {
  const _ComplianceQuestionCard({
    required this.index,
    required this.question,
  });

  final int index;
  final _ComplianceQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _kNumberBadgeBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: _kNumberBadgeFg,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  children: [
                    _radioOption('Yes', question.answer == _RequirementAnswer.yes),
                    _radioOption('Partial', question.answer == _RequirementAnswer.partial),
                    _radioOption('No', question.answer == _RequirementAnswer.no),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    color: _kEvidenceBg,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: _kEvidenceBorder),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Evidence:',
                          style: TextStyle(
                            color: AppColors.textBody,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                          ),
                        ),
                        TextSpan(
                          text: ' ${question.evidence}',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String label, bool selected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.r,
          height: 16.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? _kRadioSelected : _kRadioBorder,
            ),
          ),
          child: selected
              ? Container(
                  width: 9.6.r,
                  height: 9.6.r,
                  decoration: const BoxDecoration(
                    color: _kRadioSelected,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: _kHeaderText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Upcoming Tests & Exercises
// ---------------------------------------------------------------------------

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.items});

  final List<_Upcoming> items;

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
            'Upcoming Tests & Exercises',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < items.length; i++) ...[
            _UpcomingItem(data: items[i]),
            if (i != items.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  const _UpcomingItem({required this.data});

  final _Upcoming data;

  @override
  Widget build(BuildContext context) {
    final (bg, border, title, body, meta, icon) = switch (data.tone) {
      _UpcomingTone.blue => (
          _kUpBlueBg,
          _kUpBlueBorder,
          _kUpBlueTitle,
          _kUpBlueBody,
          _kUpBlueMeta,
          'bcm_up_activity.svg',
        ),
      _UpcomingTone.amber => (
          _kUpAmberBg,
          _kUpAmberBorder,
          _kUpAmberTitle,
          _kUpAmberBody,
          _kUpAmberMeta,
          'bcm_up_clock.svg',
        ),
      _UpcomingTone.green => (
          _kUpGreenBg,
          _kUpGreenBorder,
          _kUpGreenTitle,
          _kUpGreenBody,
          _kUpGreenMeta,
          'bcm_up_check.svg',
        ),
    };

    return Container(
      padding: EdgeInsets.all(17.w),
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
                    color: title,
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
                    color: body,
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
                    color: meta,
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
  const _ProgressBar({
    required this.percent,
    required this.color,
    required this.height,
  });

  final int percent;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        width: double.infinity,
        height: height.h,
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

enum _ProcessStatus { tested, testDue }

class _Process {
  const _Process({
    required this.name,
    required this.rto,
    required this.rpo,
    required this.mtd,
    required this.dependencies,
    required this.lastTest,
    required this.readiness,
    required this.readinessColor,
    required this.status,
  });

  final String name;
  final String rto;
  final String rpo;
  final String mtd;
  final String dependencies;
  final String lastTest;
  final int readiness;
  final Color readinessColor;
  final _ProcessStatus status;
}

enum _RequirementAnswer { yes, partial, no }

class _Requirement {
  const _Requirement({
    required this.name,
    required this.percent,
    required this.color,
    required this.questions,
  });

  final String name;
  final int percent;
  final Color color;
  final List<_ComplianceQuestion> questions;
}

class _ComplianceQuestion {
  const _ComplianceQuestion({
    required this.text,
    required this.answer,
    required this.evidence,
  });

  final String text;
  final _RequirementAnswer answer;
  final String evidence;
}

enum _UpcomingTone { blue, amber, green }

class _Upcoming {
  const _Upcoming({
    required this.title,
    required this.description,
    required this.meta,
    required this.tone,
  });

  final String title;
  final String description;
  final String meta;
  final _UpcomingTone tone;
}
