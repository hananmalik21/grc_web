import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/component_table_row_data.dart';
import 'components_table_header.dart';
import 'components_table_row.dart';

class ComponentsDataTableSkeleton extends StatelessWidget {
  final bool isDark;
  final double totalWidth;

  const ComponentsDataTableSkeleton({super.key, required this.isDark, required this.totalWidth});

  static const skeletonRows = <ComponentTableRowData>[
    ComponentTableRowData(
      name: 'Loading Component',
      code: 'CMP-000',
      category: 'EARNING',
      calculation: 'AMOUNT',
      status: 'Active',
      payroll: 'Not Mapped',
      usedInPlans: 0,
    ),
    ComponentTableRowData(
      name: 'Loading Component',
      code: 'CMP-001',
      category: 'ALLOWANCE',
      calculation: 'FORMULA',
      status: 'Inactive',
      payroll: 'Not Mapped',
      usedInPlans: 0,
    ),
    ComponentTableRowData(
      name: 'Loading Component',
      code: 'CMP-002',
      category: 'DEDUCTION',
      calculation: 'AMOUNT',
      status: 'Draft',
      payroll: 'Not Mapped',
      usedInPlans: 0,
    ),
    ComponentTableRowData(
      name: 'Loading Component',
      code: 'CMP-003',
      category: 'EARNING',
      calculation: 'FORMULA',
      status: 'Active',
      payroll: 'Not Mapped',
      usedInPlans: 0,
    ),
    ComponentTableRowData(
      name: 'Loading Component',
      code: 'CMP-004',
      category: 'ALLOWANCE',
      calculation: 'AMOUNT',
      status: 'Inactive',
      payroll: 'Not Mapped',
      usedInPlans: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentsTableHeader(isDark: isDark),
              for (final row in skeletonRows) ComponentsTableRow(row: row, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}
