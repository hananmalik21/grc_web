import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/scan_history_model.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_cloud_posture_mock_data.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureScanHistoryView extends StatelessWidget {
  final List<ScanHistoryModel>? scanHistory;

  const CloudPostureScanHistoryView({super.key, this.scanHistory});

  @override
  Widget build(BuildContext context) {
    final scans = scanHistory ?? CyberCloudPostureMockData.getMockScanHistory();
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Top Scan History Metric Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 950;
            final isTablet =
                constraints.maxWidth >= 600 && constraints.maxWidth < 950;

            final cards = [
              const _ScanKpiCard(
                title: 'LAST SCAN',
                value: '16:30',
                subtitle: '2026-06-28 UTC',
                icon: Icons.sync_rounded,
                accentColor: Color(0xFF00BCD4),
              ),
              const _ScanKpiCard(
                title: 'NEW FINDINGS',
                value: '+2',
                subtitle: 'vs previous scan',
                icon: Icons.warning_amber_rounded,
                accentColor: Color(0xFFF97316),
              ),
              const _ScanKpiCard(
                title: 'FIXED TODAY',
                value: '5',
                subtitle: 'since last scan',
                icon: Icons.check_circle_outline_rounded,
                accentColor: Color(0xFF10B981),
              ),
              const _ScanKpiCard(
                title: 'SCAN FREQUENCY',
                value: 'Daily',
                subtitle: '16:30 UTC scheduled',
                icon: Icons.filter_alt_outlined,
                accentColor: Color(0xFFA855F7),
              ),
            ];

            if (isDesktop) {
              return Row(
                children: cards
                    .map(
                      (c) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: c,
                        ),
                      ),
                    )
                    .toList(),
              );
            }

            if (isTablet) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      const Gap(10),
                      Expanded(child: cards[1]),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      const Gap(10),
                      Expanded(child: cards[3]),
                    ],
                  ),
                ],
              );
            }

            return Column(
              children: cards
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: c,
                    ),
                  )
                  .toList(),
            );
          },
        ),

        const Gap(24),

        // Scan Log Data Table
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table Header (Matches requested design)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan History',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            Text(
                              'Showing ${scans.length} records ',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              '(filtered)',
                              style: TextStyle(
                                color: const Color(0xFF10B981),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL SCANS',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${scans.length}',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
              ),

              // Scrollable Table Body
              SizedBox(
                height: 400.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final tableMinWidth = constraints.maxWidth > 900
                          ? constraints.maxWidth
                          : 900.0;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: tableMinWidth),
                          child: DataTable(
                            headingRowHeight: 40.h,
                            dataRowMinHeight: 46.h,
                            dataRowMaxHeight: 50.h,
                            horizontalMargin: 16.w,
                            columnSpacing: 18.w,
                            headingRowColor: WidgetStateProperty.all(
                              isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF8FAFC),
                            ),
                            columns: const [
                              DataColumn(label: _ScanHeaderCell('SCAN ID')),
                              DataColumn(label: _ScanHeaderCell('DATE / TIME')),
                              DataColumn(label: _ScanHeaderCell('DURATION')),
                              DataColumn(label: _ScanHeaderCell('NEW FINDINGS')),
                              DataColumn(label: _ScanHeaderCell('FIXED')),
                              DataColumn(label: _ScanHeaderCell('TOTAL FINDINGS')),
                              DataColumn(label: _ScanHeaderCell('RESOURCES SCANNED')),
                              DataColumn(label: _ScanHeaderCell('STATUS')),
                            ],
                            rows: scans.map((scan) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      scan.scanId,
                                      style: TextStyle(
                                        color: const Color(0xFF00B4D8),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      scan.dateTime,
                                      style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      scan.duration,
                                      style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      scan.newFindings > 0
                                          ? '+${scan.newFindings}'
                                          : '0',
                                      style: TextStyle(
                                        color: scan.newFindings > 0
                                            ? const Color(0xFFF97316)
                                            : const Color(0xFF64748B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${scan.fixedFindings}',
                                      style: const TextStyle(
                                        color: Color(0xFF10B981),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${scan.totalFindings}',
                                      style: TextStyle(
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${scan.resourcesScanned}',
                                      style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6.r,
                                          height: 6.r,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const Gap(6),
                                        Text(
                                          scan.status,
                                          style: TextStyle(
                                            color: const Color(0xFF10B981),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (scan.isLatest) ...[
                                          const Gap(8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF00B4D8,
                                              ).withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(4.r),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF00B4D8,
                                                ).withValues(alpha: 0.4),
                                              ),
                                            ),
                                            child: Text(
                                              'latest',
                                              style: TextStyle(
                                                color: const Color(0xFF00B4D8),
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScanKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _ScanKpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 15.sp, color: accentColor),
            ],
          ),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(6),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanHeaderCell extends StatelessWidget {
  final String text;
  const _ScanHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF94A3B8)
            : const Color(0xFF64748B),
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
