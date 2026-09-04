import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/models/cyber_security/data_security/datastore_item_model.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class DatastoresTable extends StatelessWidget {
  final List<DatastoreItemModel> datastores;
  final ValueChanged<DatastoreItemModel> onClassify;

  const DatastoresTable({
    super.key,
    required this.datastores,
    required this.onClassify,
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
                  'Datastores',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Showing ${datastores.length} sources',
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
                  DataColumn(label: _DataHeaderCell('DATA SOURCE')),
                  DataColumn(label: _DataHeaderCell('TYPE')),
                  DataColumn(label: _DataHeaderCell('CLASSIFICATION')),
                  DataColumn(label: _DataHeaderCell('SIZE')),
                  DataColumn(label: _DataHeaderCell('ENCRYPTED')),
                  DataColumn(label: _DataHeaderCell('MASKED')),
                  DataColumn(label: _DataHeaderCell('RISK')),
                  DataColumn(label: _DataHeaderCell('')),
                ],
                rows: datastores.map((ds) {
                  return DataRow(
                    cells: [
                      // Data Source
                      DataCell(
                        Text(
                          ds.source,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Type
                      DataCell(
                        Text(
                          ds.type,
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Classification
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: ds.classification.color.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: ds.classification.color.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Text(
                            ds.classification.label,
                            style: TextStyle(
                              color: ds.classification.color,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Size
                      DataCell(
                        Text(
                          ds.size,
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Encrypted
                      DataCell(
                        Text(
                          ds.isEncrypted ? '✓ Yes' : '✗ No',
                          style: TextStyle(
                            color: ds.isEncrypted
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Masked
                      DataCell(
                        Text(
                          ds.isMasked ? '✓ Yes' : '—',
                          style: TextStyle(
                            color: ds.isMasked
                                ? const Color(0xFF10B981)
                                : const Color(0xFF64748B),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
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
                            color: ds.risk.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: ds.risk.color.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            ds.risk.label,
                            style: TextStyle(
                              color: ds.risk.color,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Classify Action Button
                      DataCell(
                        InkWell(
                          onTap: () => onClassify(ds),
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
                              'Classify',
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

class _DataHeaderCell extends StatelessWidget {
  final String text;
  const _DataHeaderCell(this.text);

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
