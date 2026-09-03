import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/models/cyber_security/network_security/firewall_rule_model.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF070C18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF131E30)),
      ),
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
                  const Color(0xFF080E1C),
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
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Port
                      DataCell(
                        Text(
                          r.port,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
                                : const Color(0xFF94A3B8),
                            fontWeight: r.isSourceExposed
                                ? FontWeight.w800
                                : FontWeight.w500,
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
                                : const Color(0xFF94A3B8),
                            fontWeight: r.isDestinationExposed
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      // Service
                      DataCell(
                        Text(
                          r.service,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontWeight: FontWeight.w500,
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
                              color: const Color(0xFF0F2B38),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF00B4D8,
                                ).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'AI Analyze',
                              style: TextStyle(
                                color: const Color(0xFF00B4D8),
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
    );
  }
}

class _NetHeaderCell extends StatelessWidget {
  final String text;
  const _NetHeaderCell(this.text);

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
