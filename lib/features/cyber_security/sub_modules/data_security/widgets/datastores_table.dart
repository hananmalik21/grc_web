import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/models/datastore_item_model.dart';

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
                            color: Colors.white,
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
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
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
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
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
                              color: const Color(0xFF0F2B38),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF00B4D8,
                                ).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'Classify',
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

class _DataHeaderCell extends StatelessWidget {
  final String text;
  const _DataHeaderCell(this.text);

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
