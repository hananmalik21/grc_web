import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/models/cyber_security/network_security/firewall_rule_model.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class FirewallRulesTable extends StatelessWidget {
  final List<FirewallRuleModel> rules;
  final ValueChanged<FirewallRuleModel> onAnalyzeRule;

  const FirewallRulesTable({
    super.key,
    required this.rules,
    required this.onAnalyzeRule,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
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
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Firewall Rules',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Showing ${rules.length} rules',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
          ),
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
                  DataColumn(label: _NetHeaderCell('RULE ID')),
                  DataColumn(label: _NetHeaderCell('PROTOCOL')),
                  DataColumn(label: _NetHeaderCell('PORT')),
                  DataColumn(label: _NetHeaderCell('SOURCE')),
                  DataColumn(label: _NetHeaderCell('DESTINATION')),
                  DataColumn(label: _NetHeaderCell('SERVICE')),
                  DataColumn(label: _NetHeaderCell('RISK')),
                  DataColumn(label: _NetHeaderCell('')),
                ],
                rows: rules.map((r) {
                  return DataRow(
                    cells: [
                      // Rule ID
                      DataCell(
                        Text(
                          r.ruleId,
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      // Protocol
                      DataCell(
                        Text(
                          r.protocol,
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),

                      // Port
                      DataCell(
                        Text(
                          r.port,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),

                      // Source
                      DataCell(
                        Text(
                          r.source,
                          style: TextStyle(
                            color: r.isSourceExposed
                                ? const Color(0xFFEF4444)
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            fontWeight: r.isSourceExposed
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 11.sp,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      // Destination
                      DataCell(
                        Text(
                          r.destination,
                          style: TextStyle(
                            color: r.isDestinationExposed
                                ? const Color(0xFFEF4444)
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            fontWeight: r.isDestinationExposed
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 11.sp,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      // Service
                      DataCell(
                        Text(
                          r.service,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),

                      // Risk
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: r.risk.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: r.risk.color.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            r.risk.label,
                            style: TextStyle(
                              color: r.risk.color,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // AI Analyze Action
                      DataCell(
                        InkWell(
                          onTap: () => onAnalyzeRule(r),
                          borderRadius: BorderRadius.circular(4.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F2B38) : const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(0xFF00B4D8).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'AI Analyze',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF00B4D8) : const Color(0xFF0369A1),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    );
  }
}

class _NetHeaderCell extends StatelessWidget {
  final String text;
  const _NetHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Text(
      text,
      style: TextStyle(
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
