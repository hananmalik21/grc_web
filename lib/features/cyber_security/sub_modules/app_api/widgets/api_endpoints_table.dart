import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/models/api_endpoint_model.dart';

class ApiEndpointsTable extends StatelessWidget {
  final List<ApiEndpointModel> endpoints;
  final ValueChanged<ApiEndpointModel> onAnalyze;

  const ApiEndpointsTable({
    super.key,
    required this.endpoints,
    required this.onAnalyze,
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
                columnSpacing: 18.w,
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFF080E1C),
                ),
                columns: const [
                  DataColumn(label: _ApiHeaderCell('ENDPOINT')),
                  DataColumn(label: _ApiHeaderCell('METHOD')),
                  DataColumn(label: _ApiHeaderCell('AUTH')),
                  DataColumn(label: _ApiHeaderCell('RATE LIMIT')),
                  DataColumn(label: _ApiHeaderCell('ISSUES')),
                  DataColumn(label: _ApiHeaderCell('RISK')),
                  DataColumn(label: _ApiHeaderCell('')),
                ],
                rows: endpoints.map((ep) {
                  return DataRow(
                    cells: [
                      // Endpoint
                      DataCell(
                        Text(
                          ep.endpoint,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Method
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: ep.method.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: ep.method.color.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            ep.method.label,
                            style: TextStyle(
                              color: ep.method.color,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      // Auth
                      DataCell(
                        Text(
                          ep.auth,
                          style: TextStyle(
                            color: ep.isAuthMissing
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF94A3B8),
                            fontSize: 11.5.sp,
                            fontWeight: ep.isAuthMissing ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),

                      // Rate Limit
                      DataCell(
                        Text(
                          ep.rateLimitEnabled ? '✓ Yes' : '✗ No',
                          style: TextStyle(
                            color: ep.rateLimitEnabled
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Issues
                      DataCell(
                        Text(
                          '${ep.issuesCount}',
                          style: TextStyle(
                            color: ep.issuesCount > 0
                                ? const Color(0xFFF97316)
                                : const Color(0xFF64748B),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Risk
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: ep.risk.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: ep.risk.color.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            ep.risk.label,
                            style: TextStyle(
                              color: ep.risk.color,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Analyze Action Button
                      DataCell(
                        InkWell(
                          onTap: () => onAnalyze(ep),
                          borderRadius: BorderRadius.circular(4.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F2B38),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(0xFF00B4D8).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'Analyze',
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

class _ApiHeaderCell extends StatelessWidget {
  final String text;
  const _ApiHeaderCell(this.text);

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
