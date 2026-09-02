import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/identity_access/identity_user_model.dart';

class IdentityUsersTable extends StatelessWidget {
  final List<IdentityUserModel> users;
  final ValueChanged<IdentityUserModel> onReviewUser;

  const IdentityUsersTable({
    super.key,
    required this.users,
    required this.onReviewUser,
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
          final tableMinWidth = constraints.maxWidth > 900 ? constraints.maxWidth : 900.0;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: tableMinWidth),
              child: DataTable(
                headingRowHeight: 40.h,
                dataRowMinHeight: 46.h,
                dataRowMaxHeight: 50.h,
                horizontalMargin: 16.w,
                columnSpacing: 16.w,
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFF080E1C),
                ),
            columns: const [
              DataColumn(label: _IdHeaderCell('USER')),
              DataColumn(label: _IdHeaderCell('DEPARTMENT')),
              DataColumn(label: _IdHeaderCell('ROLE')),
              DataColumn(label: _IdHeaderCell('RISK SCORE')),
              DataColumn(label: _IdHeaderCell('ALERTS')),
              DataColumn(label: _IdHeaderCell('MFA')),
              DataColumn(label: _IdHeaderCell('PRIVILEGED')),
              DataColumn(label: _IdHeaderCell('STATUS')),
              DataColumn(label: _IdHeaderCell('')),
            ],
            rows: users.map((u) {
              return DataRow(
                cells: [
                  // User
                  DataCell(
                    Text(
                      u.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),

                  // Department
                  DataCell(
                    Text(
                      u.department,
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ),

                  // Role
                  DataCell(
                    Text(
                      u.role,
                      style: TextStyle(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ),

                  // Risk Score with mini progress bar
                  DataCell(
                    SizedBox(
                      width: 90.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 3.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: constraints.maxWidth * (u.riskScore / 100),
                                      decoration: BoxDecoration(
                                        color: u.riskScoreColor,
                                        borderRadius: BorderRadius.circular(2.r),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '${u.riskScore}',
                            style: TextStyle(
                              color: u.riskScoreColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Alerts
                  DataCell(
                    Text(
                      '${u.alertsCount}',
                      style: TextStyle(
                        color: u.alertsCount > 0 ? const Color(0xFFF97316) : const Color(0xFF64748B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // MFA
                  DataCell(
                    Text(
                      u.hasMfa ? '✓ On' : '✗ Off',
                      style: TextStyle(
                        color: u.hasMfa ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Privileged
                  DataCell(
                    u.isPrivileged
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(3.r),
                              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'PRIV',
                              style: TextStyle(
                                color: const Color(0xFFF59E0B),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Status
                  DataCell(
                    Text(
                      u.status,
                      style: TextStyle(
                        color: u.statusColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Review Button
                  DataCell(
                    InkWell(
                      onTap: () => onReviewUser(u),
                      borderRadius: BorderRadius.circular(4.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Text(
                          'Review',
                          style: TextStyle(
                            color: const Color(0xFFCBD5E1),
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

class _IdHeaderCell extends StatelessWidget {
  final String text;
  const _IdHeaderCell(this.text);

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
