import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/models/cloud_account_model.dart';

class CloudPostureAccountsView extends StatelessWidget {
  final VoidCallback? onFilterFindings;

  const CloudPostureAccountsView({super.key, this.onFilterFindings});

  @override
  Widget build(BuildContext context) {
    final accounts = CloudAccountModel.getMockAccounts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Account Cards Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1000;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1000;

            if (isDesktop) {
              return Row(
                children: accounts
                    .map(
                      (acc) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _buildAccountCard(acc),
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
                      Expanded(child: _buildAccountCard(accounts[0])),
                      const Gap(10),
                      Expanded(child: _buildAccountCard(accounts[1])),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(child: _buildAccountCard(accounts[2])),
                      const Gap(10),
                      Expanded(child: _buildAccountCard(accounts[3])),
                    ],
                  ),
                ],
              );
            }

            return Column(
              children: accounts
                  .map(
                    (acc) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildAccountCard(acc),
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
            color: const Color(0xFF070C18),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF131E30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'ACCOUNT FINDINGS BREAKDOWN',
                  style: TextStyle(
                    color: const Color(0xFF5E738E),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Divider(color: Color(0xFF131E30), height: 1),
              LayoutBuilder(
                builder: (context, constraints) {
                  final tableMinWidth = constraints.maxWidth > 900 ? constraints.maxWidth : 900.0;
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
                      const Color(0xFF080E1C),
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
                    rows: accounts.map((acc) {
                      return DataRow(
                        cells: [
                          DataCell(Text(acc.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: acc.platform.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(color: acc.platform.color.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                acc.platform.label,
                                style: TextStyle(color: acc.platform.color, fontSize: 10.sp, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          DataCell(Text(acc.accountId, style: const TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace'))),
                          DataCell(Text(acc.region, style: const TextStyle(color: Color(0xFF94A3B8)))),
                          DataCell(Text('${acc.criticalCount}', style: TextStyle(color: acc.criticalCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF64748B), fontWeight: FontWeight.bold))),
                          DataCell(Text('${acc.highCount}', style: TextStyle(color: acc.highCount > 0 ? const Color(0xFFF97316) : const Color(0xFF64748B), fontWeight: FontWeight.bold))),
                          DataCell(Text('${acc.mediumCount}', style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold))),
                          DataCell(Text('${acc.lowCount}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold))),
                          DataCell(Text('${acc.riskScore}', style: TextStyle(color: acc.riskScoreColor, fontWeight: FontWeight.w800))),
                          DataCell(Text(acc.lastScan, style: const TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Text('${acc.totalResources}', style: const TextStyle(color: Color(0xFFCBD5E1)))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
      ],
    );
  }

  Widget _buildAccountCard(CloudAccountModel acc) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF131D31),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
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
                  border: Border.all(color: acc.platform.color.withValues(alpha: 0.4)),
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
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(2),
          Text(
            acc.accountId,
            style: TextStyle(
              color: const Color(0xFF64748B),
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
                style: TextStyle(color: const Color(0xFF64748B), fontSize: 10.sp),
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
            height: 3.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
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
              _buildMiniCount('C', '${acc.criticalCount}', const Color(0xFFEF4444)),
              _buildMiniCount('H', '${acc.highCount}', const Color(0xFFF97316)),
              _buildMiniCount('M', '${acc.mediumCount}', const Color(0xFFFBBF24)),
              _buildMiniCount('L', '${acc.lowCount}', const Color(0xFF38BDF8)),
            ],
          ),
          const Gap(14),

          // Metadata footer
          Text(
            '${acc.totalResources} resources · ${acc.region} · Scan: Jun 28',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 9.5.sp,
            ),
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
        color: const Color(0xFF5E738E),
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
