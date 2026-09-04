import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureFindingsTable extends StatefulWidget {
  final List<FindingItemModel> findings;
  final ValueChanged<FindingItemModel> onOpenDetail;
  final ValueChanged<FindingItemModel> onCreateTicket;

  const CloudPostureFindingsTable({
    super.key,
    required this.findings,
    required this.onOpenDetail,
    required this.onCreateTicket,
  });

  @override
  State<CloudPostureFindingsTable> createState() =>
      _CloudPostureFindingsTableState();
}

class _CloudPostureFindingsTableState extends State<CloudPostureFindingsTable> {
  final Set<String> _selectedIds = {};
  bool _selectAll = false;

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
                      'Findings Details',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        Text(
                          'Showing ${widget.findings.length} records ',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          '(filtered)',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 12.sp,
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
                      'TOTAL FINDINGS',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '${widget.findings.length}',
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
              final tableMinWidth = constraints.maxWidth > 950
                  ? constraints.maxWidth
                  : 950.0;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: tableMinWidth),
                  child: DataTable(
                    headingRowHeight: 40.h,
                    dataRowMinHeight: 48.h,
                    dataRowMaxHeight: 52.h,
                    horizontalMargin: 16.w,
                    columnSpacing: 14.w,
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF8FAFC),
                    ),
                    columns: [
                      DataColumn(
                        label: Checkbox(
                          value: _selectAll,
                          activeColor: const Color(0xFF00B4D8),
                          side: BorderSide(color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          onChanged: (val) {
                            setState(() {
                              _selectAll = val ?? false;
                              if (_selectAll) {
                                _selectedIds.addAll(
                                  widget.findings.map((f) => f.id),
                                );
                              } else {
                                _selectedIds.clear();
                              }
                            });
                          },
                        ),
                      ),
                      _buildHeaderColumn('ID', isDark),
                      _buildHeaderColumn('RESOURCE', isDark),
                      _buildHeaderColumn('FINDING', isDark),
                      _buildHeaderColumn('SEVERITY', isDark),
                      _buildHeaderColumn('ACCOUNT', isDark),
                      _buildHeaderColumn('SERVICE', isDark),
                      _buildHeaderColumn('SCORE', isDark),
                      _buildHeaderColumn('AGE', isDark),
                      _buildHeaderColumn('STATUS', isDark),
                      _buildHeaderColumn('ACTIONS', isDark),
                    ],
                    rows: widget.findings.map((f) {
                      final isChecked = _selectedIds.contains(f.id);

                      return DataRow(
                        selected: isChecked,
                        cells: [
                          DataCell(
                            Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFF00B4D8),
                              side: BorderSide(color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedIds.add(f.id);
                                  } else {
                                    _selectedIds.remove(f.id);
                                  }
                                });
                              },
                            ),
                          ),
                          // ID
                          DataCell(
                            InkWell(
                              onTap: () => widget.onOpenDetail(f),
                              child: Text(
                                f.id,
                                style: TextStyle(
                                  color: const Color(0xFF00B4D8),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // Resource
                          DataCell(
                            Text(
                              f.resource,
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 11.sp,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          // Finding
                          DataCell(
                            Text(
                              f.finding,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // Severity
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: f.severity.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: f.severity.color.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                f.severity.label,
                                style: TextStyle(
                                  color: f.severity.color,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          // Account
                          DataCell(
                            Text(
                              f.account,
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          // Service
                          DataCell(
                            Text(
                              f.service,
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          // Risk Score
                          DataCell(
                            Text(
                              f.riskScore.toString(),
                              style: TextStyle(
                                color: f.riskScore >= 90
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFFF97316),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          // Age
                          DataCell(
                            Text(
                              f.age,
                              style: TextStyle(
                                color: const Color(0xFF10B981),
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          // Status
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6.r,
                                  height: 6.r,
                                  decoration: BoxDecoration(
                                    color: f.status.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  f.status.label,
                                  style: TextStyle(
                                    color: f.status.color,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Actions
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => widget.onCreateTicket(f),
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF00B4D8,
                                      ).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF00B4D8,
                                        ).withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      '+ Ticket',
                                      style: TextStyle(
                                        color: const Color(0xFF00B4D8),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(6),
                                InkWell(
                                  onTap: () => widget.onOpenDetail(f),
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Text(
                                      'Detail',
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
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
    );
  }

  DataColumn _buildHeaderColumn(String label, bool isDark) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
