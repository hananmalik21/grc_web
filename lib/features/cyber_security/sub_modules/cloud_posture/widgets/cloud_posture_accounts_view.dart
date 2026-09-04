import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/cloud_account_model.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_cloud_posture_mock_data.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureAccountsView extends StatelessWidget {
  final List<CloudAccountModel>? accounts;
  final VoidCallback? onFilterFindings;

  const CloudPostureAccountsView({
    super.key,
    this.accounts,
    this.onFilterFindings,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccounts =
        accounts ?? CyberCloudPostureMockData.getMockAccounts();
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Account Cards Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1000;
            final isTablet =
                constraints.maxWidth >= 600 && constraints.maxWidth < 1000;

            if (isDesktop) {
              return Row(
                children: effectiveAccounts
                    .map(
                      (acc) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: _buildAccountCard(context, acc, isDark),
                        ),
                      ),
                    )
                    .toList(),
              );
            }

            if (isTablet && effectiveAccounts.length >= 4) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildAccountCard(context, effectiveAccounts[0], isDark)),
                      const Gap(10),
                      Expanded(child: _buildAccountCard(context, effectiveAccounts[1], isDark)),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(child: _buildAccountCard(context, effectiveAccounts[2], isDark)),
                      const Gap(10),
                      Expanded(child: _buildAccountCard(context, effectiveAccounts[3], isDark)),
                    ],
                  ),
                ],
              );
            }

            return Column(
              children: effectiveAccounts
                  .map(
                    (acc) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _buildAccountCard(context, acc, isDark),
                    ),
                  )
                  .toList(),
            );
          },
        ),

        const Gap(24),

        // Account Findings Breakdown Table
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
                          'Account Breakdown',
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
                              'Showing ${effectiveAccounts.length} records ',
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
                          'TOTAL ACCOUNTS',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${effectiveAccounts.length}',
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
                        dataRowMinHeight: 48.h,
                        dataRowMaxHeight: 52.h,
                        horizontalMargin: 16.w,
                        columnSpacing: 16.w,
                        headingRowColor: WidgetStateProperty.all(
                          isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF8FAFC),
                        ),
                        columns: const [
                          DataColumn(label: _HeaderCell('ACCOUNT')),
                          DataColumn(label: _HeaderCell('PLATFORM')),
                          DataColumn(label: _HeaderCell('ACCOUNT ID')),
                          DataColumn(label: _HeaderCell('REGION')),
                          DataColumn(label: _HeaderCell('CRITICAL')),
                          DataColumn(label: _HeaderCell('HIGH')),
                          DataColumn(label: _HeaderCell('MEDIUM')),
                          DataColumn(label: _HeaderCell('LOW')),
                          DataColumn(label: _HeaderCell('RISK SCORE')),
                          DataColumn(label: _HeaderCell('LAST SCAN')),
                          DataColumn(label: _HeaderCell('RESOURCES')),
                        ],
                        rows: effectiveAccounts.map((acc) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  acc.name,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: acc.platform.color.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: acc.platform.color.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    acc.platform.label,
                                    style: TextStyle(
                                      color: acc.platform.color,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  acc.accountId,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  acc.region,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.criticalCount}',
                                  style: TextStyle(
                                    color: acc.criticalCount > 0
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.highCount}',
                                  style: TextStyle(
                                    color: acc.highCount > 0
                                        ? const Color(0xFFF97316)
                                        : const Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.mediumCount}',
                                  style: const TextStyle(
                                    color: Color(0xFFFBBF24),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.lowCount}',
                                  style: const TextStyle(
                                    color: Color(0xFF38BDF8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.riskScore}',
                                  style: TextStyle(
                                    color: acc.riskScoreColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  acc.lastScan,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${acc.totalResources}',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                                  ),
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

  Widget _buildAccountCard(BuildContext context, CloudAccountModel acc, bool isDark) {
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
          // Platform Badge & Health dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: acc.platform.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: acc.platform.color.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  acc.platform.label,
                  style: TextStyle(
                    color: acc.platform.color,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: acc.healthColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    acc.healthStatus,
                    style: TextStyle(
                      color: acc.healthColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(10),

          // Name & ID
          Text(
            acc.name,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(2),
          Text(
            acc.accountId,
            style: TextStyle(
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontSize: 11.sp,
              fontFamily: 'monospace',
            ),
          ),
          const Gap(12),

          // Risk Score Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Risk score',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '${acc.riskScore}',
                style: TextStyle(
                  color: acc.riskScoreColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Gap(4),
          Container(
            height: 4.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * (acc.riskScore / 100),
                    decoration: BoxDecoration(
                      color: acc.riskScoreColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(14),

          // Severity Counts mini grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniCount(
                'C',
                '${acc.criticalCount}',
                const Color(0xFFEF4444),
              ),
              _buildMiniCount('H', '${acc.highCount}', const Color(0xFFF97316)),
              _buildMiniCount(
                'M',
                '${acc.mediumCount}',
                const Color(0xFFFBBF24),
              ),
              _buildMiniCount('L', '${acc.lowCount}', const Color(0xFF38BDF8)),
            ],
          ),
          const Gap(14),

          // Metadata footer
          Text(
            '${acc.totalResources} resources · ${acc.region} · Scan: Jun 28',
            style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.5.sp),
          ),
          const Gap(10),

          // Action link button
          InkWell(
            onTap: onFilterFindings,
            child: Row(
              children: [
                Text(
                  'View findings →',
                  style: TextStyle(
                    color: const Color(0xFF00B4D8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCount(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(2),
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

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
