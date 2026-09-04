import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/models/cyber_security/app_api/api_endpoint_model.dart';
import 'package:grc/core/theme/theme_extensions.dart';

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
                  'API Endpoints',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Showing ${endpoints.length} endpoints',
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
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Method
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
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
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            fontSize: 11.5.sp,
                            fontWeight: ep.isAuthMissing
                                ? FontWeight.w700
                                : FontWeight.w500,
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
                                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
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
                              'Analyze',
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

class _ApiHeaderCell extends StatelessWidget {
  final String text;
  const _ApiHeaderCell(this.text);

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
